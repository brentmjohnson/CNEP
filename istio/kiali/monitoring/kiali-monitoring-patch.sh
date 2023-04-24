kubectl patch deployment/kiali-operator -n istio-operator --type json -p='[
  {"op": "remove", "path": "/spec/template/metadata/annotations/prometheus.io~1scrape"}
]'
kubectl patch deployment/kiali -n istio-system --type json -p='[
  {"op": "remove", "path": "/spec/template/metadata/annotations/prometheus.io~1port"},
  {"op": "remove", "path": "/spec/template/metadata/annotations/prometheus.io~1scrape"}
]'