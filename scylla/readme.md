https://operator.docs.scylladb.com/stable/generic.html

wget https://github.com/scylladb/scylla-operator/archive/refs/tags/v1.7.2.tar.gz && tar -xvf v1.7.2.tar.gz && rm v1.7.2.tar.gz

kubectl apply -f ./scylla/operator.yaml

kubectl apply -f ./scylla/cluster.yaml

kubectl -n scylla port-forward svc/simple-cluster-client 5090 &

kubectl -n ingress-apisix port-forward svc/apisix-gateway 9042 &

kubectl apply -f ./scylla/ingress/apisixRoute.yaml
kubectl delete -f ./scylla/apisixRoute.yaml

kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl "http://127.0.0.1:9180/apisix/admin/stream_routes/1" -H "X-API-KEY: <secret>" -X PUT -d '
{
    "server_port": 9042,
    "upstream": {
        "service_name": "simple-cluster-client.scylla.svc",
        "type": "roundrobin",
        "discovery_type": "dns"
    }
}'

cqlsh -u <user> -p <password> --cqlversion="3.3.1"

DESCRIBE KEYSPACE system_auth
ALTER KEYSPACE system_auth WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };

CREATE ROLE <user> with SUPERUSER = true AND LOGIN = true and PASSWORD = <password>;

https://docs.datastax.com/en/security/5.1/security/Auth/secCreateRootAccount.html

monitoring:
wget https://github.com/scylladb/scylla-monitoring/archive/refs/tags/scylla-monitoring-4.1.0.tar.gz && tar -xvf scylla-monitoring-4.1.0.tar.gz && rm scylla-monitoring-4.1.0.tar.gz 

# seedless gossip loses a node for 1 hour before rejoining quorum
nodetool setlogginglevel gossip info
istioctl proxy-config log scylla-dc-default-1.scylla --level=debug
istioctl proxy-config log scylla-dc-default-1.scylla --level=warning