kubectl patch deployment/dashboard-metrics-scraper -n kubernetes-dashboard --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "dashboard-metrics-scraper"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "1.0.8"}
]'
kubectl patch deployment/kubernetes-dashboard -n kubernetes-dashboard --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "kubernetes-dashboard"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "2.6.0"}
]'
kubectl patch service/dashboard-metrics-scraper -n kubernetes-dashboard --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service dashboard-metrics-scraper -n kubernetes-dashboard -o json  | jq '.spec.ports | map(.port == 8000) | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/kubernetes-dashboard -n kubernetes-dashboard --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service kubernetes-dashboard -n kubernetes-dashboard -o json  | jq '.spec.ports | map(.port == 443) | index(true)')/appProtocol', "value": "tls"}
]'