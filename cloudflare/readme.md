1. kubectl create namespace cloudflared
<!-- 2. kubectl create secret generic tunnel-credentials -n cloudflared \
--from-file=k8s-control-0=./cloudflare/tunnels/example-k8s-control-0.json \
--from-file=k8s-control-1=./cloudflare/tunnels/example-k8s-control-1.json \
--from-file=k8s-control-2=./cloudflare/tunnels/example-k8s-control-2.json -->
2. kubectl create secret generic tunnel-credentials -n cloudflared \
--from-file=credentials.json=./cloudflare/tunnels/example.json
3. kubectl apply -f ./cloudflare/cloudflared-configmap.yaml
3. kubectl apply -f ./cloudflare/cloudflared-replicaset.yaml