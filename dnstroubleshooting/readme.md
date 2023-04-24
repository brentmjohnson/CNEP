kubectl apply -f ./dnstroubleshooting/dnsutils.yaml

kubectl run -it --tty -n cert-manager --rm debug --image=alpine --labels="app=debug,version=latest" --restart=Never -- sh

kubectl run -it --tty --rm debug --image=alpine --annotations='proxy.istio.io/config="proxyMetadata:\n OUTPUT_CERTS: /etc/istio-output-certs\n",sidecar.istio.io/userVolumeMount=[{\"name\": \"istio-certs\", \"mountPath\": \"/etc/istio-output-certs\"}]' --restart=Never -- sh --dry-run=client -o yaml

kubectl run -it --tty -n k8ssandra-operator --rm debug --image=alpine --restart=Never -- sh

kubectl run -it --tty --rm debug --image=alpine --restart=Never -- sh

kubectl run -it --tty --rm debug --image=alpine --labels="app=debug,version=latest" --restart=Never -- sh

kubectl run debug --image=alpine --labels="app=debug,version=latest" --restart=Never --dry-run=client -o yaml > ./dnstroubleshooting/debug-pod.yaml

kubectl apply -f ./dnstroubleshooting/debug-pod.yaml
kubectl run -it --tty --rm debug

kubectl run -it --tty --rm debug --image=alpine --overrides='$(<./datastore/dnstroubleshooting/debug-pod.json)'

./dataStore/dnstroubleshooting/run-yaml.sh ./dataStore/dnstroubleshooting/debug-pod.yaml

apk add curl
apk update && apk add curl busybox-extras bind-tools dnstracer
apk update && apk add bind-tools
apk add dnstracer

curl -u "admin:admin" http://opensearch.opensearch-operator-system.svc.cluster.local:9200

opensearch.opensearch-operator-system:9300

kubectl 

apk add hping3 --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
sudo hping3 opensearch-discovery.opensearch-operator-system -S -p 9200 -i u10000 | egrep --line-buffered 'rtt=[0-9]{3,}\.'
sudo hping3 172.18.0.4 --icmp -i u10000
sudo hping3 127.0.0.1 --icmp -i u10000 | egrep 'rtt=[0-9]{3,}\.'

sudo hping3 --traceroute -V -1 opensearch-masters.opensearch-operator-system

https://github.blog/2019-11-21-debugging-network-stalls-on-kubernetes/

https://gist.github.com/MarioHewardt/5759641727aae880b29c8f715ba4d30f

sudo python3 ./dnstroubleshooting/traceicmpsoftirq.py

kubectl exec -i -n opensearch-operator-system -t opensearch-masters-0 --container opensearch -- /bin/bash

hping3 10.244.245.81 -S -p 9200 -i u10000 | egrep 'rtt=[0-9]{3,}\.'
opensearch-masters-0.opensearch-operator-system.pod.cluster.local

kubectl run -it --tty --rm debug --image=alpine --labels="app=debug,version=latest" --restart=Never -- sh
kubectl cp monitoring/prometheus-k8s-0:/etc/prom-certs/ ./dnstroubleshooting/prom-certs
mkdir /etc/prom-certs/
kubectl cp ./dnstroubleshooting/prom-certs default/debug:/etc/

curl --cacert /etc/prom-certs/root-cert.pem --cert /etc/prom-certs/cert-chain.pem --key /etc/prom-certs/key.pem --insecure https://10.244.245.105:6443/metrics -v

curl https://10.244.245.105:6443/metrics