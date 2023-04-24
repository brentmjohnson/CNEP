Setup:
https://docs-v2.k8ssandra.io/install/local/single-cluster-kustomize/

Quickstarts:
https://docs-v2.k8ssandra.io/quickstarts/developer/

yaml:
https://github.com/k8ssandra/k8ssandra/blob/main/charts/k8ssandra/values.yaml

./setup-kind-multicluster.sh --kind-worker-nodes 1

kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.yaml

kustomize build "github.com/k8ssandra/k8ssandra-operator/config/deployments/control-plane?ref=v1.0.1" | kubectl apply --server-side -f -

./cassandra/operatorApply.sh

kubectl -n k8ssandra-operator port-forward svc/demo-dc1-stargate-service 8080 8081 8082 8084 8085 9042 &

kubectl -n k8ssandra-operator port-forward svc/demo-dc1-reaper-service 9393:8080 &

kubectl -n k8ssandra-operator port-forward svc/cassandra-dc1-service 9042:9042 &
kubectl -n k8ssandra-operator port-forward svc/cassandra-dc1-stargate-service 9042:9042 &

CASS_PASSWORD=$(kubectl get secret demo-superuser -n k8ssandra-operator -o=jsonpath='{.data.password}' | base64 --decode)
echo $CASS_PASSWORD


curl -L -X POST 'http://localhost:8081/v1/auth' -H 'Content-Type: application/json' --data-raw '{"username": <user>, "password": <password>}'

763f1a15-b221-442d-bb50-28f8405b02df

http://127.0.0.1:8080/playground

kubectl apply -f ./cassandra/apisixRoute.yaml
kubectl delete -f ./cassandra/apisixRoute.yaml

./cqlsh -u <user> -p <password>

CASS_PASSWORD=$(kubectl get secret reaper-ui-secret -n k8ssandra-operator -o=jsonpath='{.data.password}' | base64 --decode)

echo $CASS_PASSWORD

reaper-ui-secret

http://localhost:9393/webui/index.html

cqlsh -u <user> -p <password>

./cassandra-stress write n=1000000 -rate threads=50 -mode native cql3 user=<user> password=<password> protocolVersion=4

./cassandra-stress read n=1000000 -rate threads=50 -mode native cql3 user=<user> password=<password> protocolVersion=4

wget https://github.com/k8ssandra/k8ssandra/archive/refs/tags/v1.5.0.tar.gz && tar -xvf v1.5.0.tar.gz && rm v1.5.0.tar.gz

wget https://github.com/k8ssandra/k8ssandra-operator/archive/refs/tags/v1.1.1.tar.gz && tar -xvf v1.1.1.tar.gz && rm v1.1.1.tar.gz

kustomize build --load-restrictor LoadRestrictionsNone ./cassandra/deployment