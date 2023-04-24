kubectl patch deployment/flink-kubernetes-operator -n flink --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "flink-kubernetes-operator"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "1.0.1"}
]'
kubectl patch service/flink-rest -n flink --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service flink-rest -n flink -o json  | jq '.spec.ports | map(.name == "rest") | index(true)')/appProtocol', "value": "http"}
]'