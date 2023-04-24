kubectl patch deployment/jaeger-operator -n observability --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "jaeger-operator"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "1.35.0"}
]'
kubectl patch service/jaeger-operator-webhook-service -n observability --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service jaeger-operator-webhook-service -n observability -o json  | jq '.spec.ports | map(.port == 443) | index(true)')/appProtocol', "value": "tls"}
]'

# kubectl patch service/jaeger-collector-headless -n observability --type json -p='[
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service jaeger-collector-headless -n observability -o json  | jq '.spec.ports | map(.name == "grpc-http") | index(true)')/appProtocol', "value": "http"}
# ]'