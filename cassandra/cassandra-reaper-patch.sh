cat << EOF | kubectl -n k8ssandra-operator apply -f -
{
   "apiVersion": "batch/v1",
   "kind": "Job",
   "metadata": {
      "name": "cassandra-dc1-reaper-init"
   },
   "spec": {
      "template": {
         "spec": {
            "containers": [
               $(kubectl get deployment cassandra-dc1-reaper -n k8ssandra-operator -o json  | jq '.spec.template.spec.initContainers[0]')
            ],
            "restartPolicy": "OnFailure"
         }
      }
   }
}
EOF
kubectl patch deployment/cassandra-dc1-reaper -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": "/spec/template/spec/initContainers", "value": []},
]'
