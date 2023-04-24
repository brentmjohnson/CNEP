# kubectl patch alertmanager/alertmanager-main -n monitoring --type json -p='[
#   {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "alertmanager"},
#   {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "0.24.0"}
# ]'

# kubectl patch deployment/blackbox-exporter -n monitoring --type json -p='[
#   {"op": "add", "path": "/spec/template/spec/containers/0/ports/1", "value": {
#       name: "https",
#       containerPort: 9115,
#       protocol: "TCP"
#     }
#   }
# ]'
kubectl patch service/alertmanager-main -n monitoring --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service alertmanager-main -n monitoring -o json  | jq '.spec.ports | map(.name == "web") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/alertmanager-main -n monitoring --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service alertmanager-main -n monitoring -o json  | jq '.spec.ports | map(.name == "reloader-web") | index(true)')/appProtocol', "value": "http"}
]'
# kubectl patch service/alertmanager-operated -n monitoring --type json -p='[
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service alertmanager-operated -n monitoring -o json  | jq '.spec.ports | map(.name == "web") | index(true)')/appProtocol', "value": "http"}
# ]'
# kubectl patch service/blackbox-exporter -n monitoring --type json -p='[
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service blackbox-exporter -n monitoring -o json  | jq '.spec.ports | map(.name == "https") | index(true)')/appProtocol', "value": "http"},
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service blackbox-exporter -n monitoring -o json  | jq '.spec.ports | map(.name == "probe") | index(true)')/appProtocol', "value": "http"}
# ]'
# kubectl patch service/prometheus-k8s -n monitoring --type json -p='[
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service prometheus-k8s -n monitoring -o json  | jq '.spec.ports | map(.name == "web") | index(true)')/appProtocol', "value": "http"}
# ]'
# kubectl patch service/prometheus-k8s -n monitoring --type json -p='[
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service prometheus-k8s -n monitoring -o json  | jq '.spec.ports | map(.name == "reloader-web") | index(true)')/appProtocol', "value": "http"}
# ]'
# kubectl patch service/prometheus-operated -n monitoring --type json -p='[
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service prometheus-operated -n monitoring -o json  | jq '.spec.ports | map(.name == "web") | index(true)')/appProtocol', "value": "http"}
# ]'