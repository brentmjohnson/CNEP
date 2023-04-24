#!/bin/sh
# https://gist.github.com/WoozyMasta/ee80d7ad7cfb6dd787daff036a1078d2
set -eu

# Listen address for all docker.io/registry instances
listen_address=k8s-lb
# Listen port for the first container
# all subsequent ports for containers will be incremented by one
listen_port_first=5001
insecure=true
# docker.io credentials
docker_username=<user>
docker_password=<password>

# Array with a list of proxied container registries
# k8s.gcr.io == registry.k8s.io
set -- \
  "docker.io=registry-1.docker.io" \
  "quay.io" \
  "gcr.io" \
  "registry.k8s.io" \
  "ghcr.io" \
  "mcr.microsoft.com" \
  "registry.gitlab.com"

work_dir="$(dirname "$(readlink -f "$0")")"
data_dir="$work_dir/containers-registry-proxy"

# Get container engine binary
if command -v podman &>/dev/null; then
  cre=podman
elif command -v docker &>/dev/null; then
  cre=docker
else
  >&2 printf '\n%s\n' 'Podman or Docker not installed!'
  exit 1
fi

>&2 printf '\n%s\n\n' \
  'Add this lines to /etc/containers/registries.conf config:'

printf '%s\n' 'unqualified-search-registries = ['
for item in "$@"; do
  printf '  "%s",\n' "$item" | sed 's/=.*",/",/';
done
printf '%s\n\n' ']'

# Start Redis
mkdir -p "$data_dir/redis-data"
$cre run --restart always --detach --name registry-cache-redis \
  --publish 127.0.0.1:6379:6379 \
  --publish [::1]:6379:6379 \
  --volume "$data_dir/redis-data:/data" \
  docker.io/redis:6 redis-server --appendonly yes >/dev/null

# Start Distribution's
port=$listen_port_first
for i in "$@"; do
  : "${port:=$listen_port_first}"
  registry="${i/=*/}"
  registry_url="${i/*=/}"

  mkdir -p "$data_dir/$registry"

  creds=$([[ $registry = "docker.io" ]] && echo '
    --env REGISTRY_PROXY_USERNAME='$docker_username'
    --env REGISTRY_PROXY_PASSWORD='$docker_password || echo -n)

  $cre run --restart always --detach --name "registry-cache-$registry" \
    --publish $port:5000 \
    --env REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
    --env REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/cache \
    --env REGISTRY_STORAGE_CACHE_BLOBDESCRIPTOR=redis \
    --env REGISTRY_STORAGE_DELETE_ENABLED=true \
    --env REGISTRY_PROXY_REMOTEURL=https://$registry_url $creds\
    --env REGISTRY_REDIS_ADDR=0.0.0.0:6379 \
    --env REGISTRY_LOG_LEVEL=debug \
    --volume "$data_dir/$registry":/cache \
    docker.io/registry:2 >/dev/null

  cat <<EOF
[[registry]]
prefix = "$registry"
location = "$registry"
[[registry.mirror]]
prefix = "$registry"
location = "$listen_address:$port"
insecure = $insecure

EOF
  port=$((port+1))

done

>&2 printf '\n%s\n' 'Done.'

# docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
# netstat -tulpn | grep 5001
# TOKEN=$(curl --user '<user>:<password>' "https://auth.docker.io/token?service=registry.docker.io&scope=repository:ratelimitpreview/test:pull" | jq -r .token)
# curl --head -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/ratelimitpreview/test/manifests/latest 2>&1
# WARNING! expanding vscode connected registries on a mirror uses QUOTA!!!