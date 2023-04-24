# private registry
vi /etc/apk/repositories
enable http://dl-cdn.alpinelinux.org/alpine/edge/community
apk update
apk add docker-registry
vi /etc/docker-registry/config.yml
    storage:
      delete:
        enabled: true
    #auth:
    #  htpasswd:
    #    realm: basic-realm
    #    path: /etc/registry
rc-update add docker-registry default
rc-service docker-registry start

sudo vi /etc/docker/daemon.json
    "insecure-registries" : ["10.0.0.2:5000","k8s-lb:5000"]
sudo service docker restart && service docker status
docker tag registry:2 k8s-lb:5000/registry:2
docker push k8s-lb:5000/registry:2

# pull-through cache
<!-- https://gist.github.com/WoozyMasta/ee80d7ad7cfb6dd787daff036a1078d2 -->
apk update
apk add docker
rc-update add docker boot
service docker start
docker ps
scp ./hyper-v/create-container-registry-proxies.sh root@10.0.0.2:/tmp
chmod +x /tmp/create-container-registry-proxies.sh
/tmp/create-container-registry-proxies.sh