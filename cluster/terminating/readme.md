1. kubectl get namespace redis -o json > ./cluster/terminating/tmp.json
2. set "spec.finalizers" = []
3. kubectl proxy
3. curl -k -H "Content-Type: application/json" -X PUT --data-binary @./cluster/terminating/tmp.json http://127.0.0.1:8001/api/v1/namespaces/redis/finalize