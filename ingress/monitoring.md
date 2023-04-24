kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl "http://127.0.0.1:9180/apisix/admin/stream_routes/1" -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PUT -d '
{
    "uri": "/hello",
    "plugins": {
        "prometheus":{}
    },
    "upstream": {
        "type": "roundrobin",
        "nodes": {
            "127.0.0.1:80": 1
        }
    }
}'

kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl -i "http://127.0.0.1:9080/apisix/prometheus/metrics"

https://apisix.apache.org/blog/2021/11/30/use-apisix-ingress-in-kubesphere/

https://github.com/apache/apisix-helm-chart/pull/192