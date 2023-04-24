kubectl patch deployment/strimzi-cluster-operator -n kafka --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "strimzi-cluster-operator"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "0.29.0"}
]'