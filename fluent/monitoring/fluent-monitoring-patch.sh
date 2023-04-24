kubectl patch daemonset/fluent-bit -n fluent --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "fluent-bit"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "v1.9.4"}
]'
kubectl patch deployment/fluent-operator -n fluent --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "fluent-operator"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "v1.1.0"}
]'