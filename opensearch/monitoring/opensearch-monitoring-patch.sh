kubectl patch deployment/opensearch-dashboards -n opensearch-operator-system --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "opensearch-dashboards"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "2.1.0"}
]'
kubectl patch deployment/opensearch-exporter-prometheus-elasticsearch-exporter -n opensearch-operator-system --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "1.3.0"}
]'
kubectl patch statefulSet/opensearch-masters -n opensearch-operator-system --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "opensearch"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "2.1.0"}
]'
kubectl patch deployment/opensearch-operator-controller-manager -n opensearch-operator-system --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "opensearch-operator"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "2.0.0"}
]'
kubectl patch service/opensearch -n opensearch-operator-system --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service opensearch -n opensearch-operator-system -o json  | jq '.spec.ports | map(.name == "transport") | index(true)')/appProtocol', "value": "tcp"}
]'
kubectl patch service/opensearch -n opensearch-operator-system --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service opensearch -n opensearch-operator-system -o json  | jq '.spec.ports | map(.name == "metrics") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/opensearch -n opensearch-operator-system --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service opensearch -n opensearch-operator-system -o json  | jq '.spec.ports | map(.name == "rca") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/opensearch-discovery -n opensearch-operator-system --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service opensearch-discovery -n opensearch-operator-system -o json  | jq '.spec.ports | map(.name == "transport") | index(true)')/appProtocol', "value": "tcp"}
]'
kubectl patch service/opensearch-masters -n opensearch-operator-system --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service opensearch-masters -n opensearch-operator-system -o json  | jq '.spec.ports | map(.name == "transport") | index(true)')/appProtocol', "value": "tcp"}
]'
kubectl patch serviceMonitor/opensearch-exporter-prometheus-elasticsearch-exporter -n opensearch-operator-system --type json -p='[
  {"op": "replace", "path": "/spec/endpoints/0/tlsConfig", "value": {
      "caFile": "/etc/prom-certs/root-cert.pem",
      "certFile": "/etc/prom-certs/cert-chain.pem",
      "insecureSkipVerify": true,
      "keyFile": "/etc/prom-certs/key.pem"
    }
  }
]'