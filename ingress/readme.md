https://github.com/apache/apisix-ingress-controller/blob/2122d76fd28cc7bce54e8f52e2d4c9d04a1e852a/install.md#kustomize-support
https://github.com/apache/apisix-helm-chart
https://github.com/apache/apisix-dashboard

https://github.com/bisakhmondal/apisix/blob/28150b8869660fdd446e3d4e8058a8eb8351063d/docs/en/latest/stream-proxy.md

wget https://github.com/apache/apisix-ingress-controller/archive/refs/tags/1.4.1.tar.gz && tar -xvf 1.4.1.tar.gz && rm 1.4.1.tar.gz
wget https://github.com/apache/apisix/archive/refs/tags/2.14.1.tar.gz && tar -xvf 2.14.1.tar.gz && rm 2.14.1.tar.gz
wget https://github.com/apache/apisix-helm-chart/archive/refs/tags/apisix-0.10.0.tar.gz && tar -xvf apisix-0.10.0.tar.gz && rm apisix-0.10.0.tar.gz

kubectl create namespace ingress-apisix

helm repo add apisix https://charts.apiseven.com
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade -i apisix apisix/apisix \
  --set gateway.type=NodePort \
  --set ingress-controller.enabled=true \
  --namespace ingress-apisix \
  --set ingress-controller.config.apisix.serviceNamespace=ingress-apisix \
  --set etcd.replicaCount=1 \
  --set gateway.stream.enabled=true \
  --set apisix.stream_proxy.only=false \
  --set gateway.stream.tcp[0]=9042 \
  --set serviceMonitor.enabled=true \
  --set ingress-controller.serviceMonitor.enabled=true \
  --debug \
  --dry-run \
  > ./ingress/helm.yaml

kubectl patch configmap/apisix \
  -n ingress-apisix \
  --type merge \
  --patch-file ./ingress/apisix-patch.yaml

kubectl patch configmap/apisix-configmap \
  -n ingress-apisix \
  --type merge \
  --patch-file ./ingress/apisix-configmap-patch.yaml

kubectl rollout restart -n ingress-apisix deployment apisix
kubectl rollout restart -n ingress-apisix deployment apisix-ingress-controller

helm install apisix-dashboard apisix/apisix-dashboard --namespace ingress-apisix

kubectl apply -k ./ingress/apisix-ingress-controller-master/samples/deploy/crd/v1

kubectl get service --namespace ingress-apisix

export NODE_PORT=$(kubectl get --namespace ingress-apisix -o jsonpath="{.spec.ports[0].nodePort}" services apisix-gateway)
export NODE_IP=$(kubectl get nodes --namespace ingress-apisix -o jsonpath="{.items[0].status.addresses[0].address}")
echo http://$NODE_IP:$NODE_PORT

export POD_NAME=$(kubectl get pods --namespace ingress-apisix -l "app.kubernetes.io/name=apisix-dashboard,app.kubernetes.io/instance=apisix-dashboard" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace ingress-apisix $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit http://127.0.0.1:8080 to use your application"
kubectl --namespace ingress-apisix port-forward $POD_NAME 8080:$CONTAINER_PORT

kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl http://127.0.0.1:9080

kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl http://127.0.0.1:9080/headers -H 'Host: local.httpbin.org'

curl http://172.18.0.3:31044/kubernetes-dashboard

kubectl exec -it -n ${namespace of Apache APISIX} ${Pod name of Apache APISIX} -- curl http://127.0.0.1:9180/apisix/admin/routes -H 'X-API-Key: edd1c9f034335f136f87ad84b625c8f1'

kubectl -n ingress-apisix port-forward svc/apisix-gateway 9042 &

kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl "http://127.0.0.1:9180/apisix/admin/stream_routes/1" -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PUT -d '
{
    "server_port": 9042,
    "upstream": {
        "service_name": "demo-dc1-stargate-service.k8ssandra-operator:9042",
        "type": "roundrobin",
        "discovery_type": "dns"
    }
}'

kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl "http://127.0.0.1:9180/apisix/admin/stream_routes/1" -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PUT -d '
{
    "server_port": 9042,
    "upstream": {
        "nodes": {
            "10.244.1.5:9042": 1
        },
        "type": "roundrobin"
    }
}'

kubectl delete -f ./ingress/apisixRoute.yaml
kubectl apply -f ./ingress/apisixRoute.yaml

kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl "http://127.0.0.1:9180/apisix/admin/stream_routes" -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1"

kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl "http://127.0.0.1:9180/apisix/admin/stream_routes/1" -X DELETE -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1"

kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl "http://127.0.0.1:9180/apisix/admin/upstreams/b6033145" -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1"

kubectl apply -f ./ingress/apisix-admin-service.yaml

ps -ef | grep nginx

kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl "http://127.0.0.1:9180/apisix/admin/stream_routes/1" -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PUT -d '
{
  "server_port": 9042,
  "upstream_id":"26b8b210",
  "plugins": {
    "prometheus": {
      "prefer_name": true
    }
  }
}'

curl -X PUT \
  http://apisix-admin.ingress-apisix.svc.cluster.local:9180/apisix/admin/global_rules/1 \
  -H 'Content-Type: application/json' \
  -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
  -d '{
        "plugins": {
            "redirect": {
                "http_to_https": true
            }
        }
    }' \
  -v

curl -X DELETE http://apisix-admin.ingress-apisix.svc.cluster.local:9180/apisix/admin/global_rules/1 \
  -H 'Content-Type: application/json' \
  -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
  -v

curl http://apisix-admin.ingress-apisix.svc.cluster.local:9180/apisix/admin/global_rules \
  -H 'Content-Type: application/json' \
  -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
  -v

