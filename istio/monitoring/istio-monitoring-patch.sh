kubectl patch daemonSet/istio-cni-node -n istio-system --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "istio-cni"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "1.14.1"}
]'
kubectl patch deployment/istio-egressgateway -n istio-system --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "1.14.1"}
]'
kubectl patch deployment/istiod -n istio-system --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "1.14.1"}
]'