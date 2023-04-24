# kubectl patch deployment/opentelemetry-operator-controller-manager -n opentelemetry-operator-system --type json -p='[
#   {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "opentelemetry-operator"},
#   {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "0.55.0"}
# ]'
# kubectl patch service/opentelemetry-operator-webhook-service -n opentelemetry-operator-system --type json -p='[
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service opentelemetry-operator-webhook-service -n opentelemetry-operator-system -o json  | jq '.spec.ports | map(.port == 443) | index(true)')/appProtocol', "value": "tls"}
# ]'
kubectl patch service/opentelemetry-operator-controller-manager-metrics-service -n opentelemetry-operator-system --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service opentelemetry-operator-controller-manager-metrics-service -n opentelemetry-operator-system -o json  | jq '.spec.ports | map(.name == "metrics") | index(true)')/appProtocol', "value": "http"}
]'