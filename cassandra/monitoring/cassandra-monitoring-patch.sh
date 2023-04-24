kubectl patch deployment/cass-operator-controller-manager -n k8ssandra-operator --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "cass-operator"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "1.11.0"}
]'
kubectl patch deployment/cassandra-dc1-default-stargate-deployment -n k8ssandra-operator --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "stargate"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "1.0.45"},
]'
kubectl patch statefulSet/cassandra-dc1-default-sts -n k8ssandra-operator --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "cassandra"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "4.0.4"}
]'
kubectl patch deployment/cassandra-dc1-reaper -n k8ssandra-operator --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "reaper"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "3.1.1"}
]'
kubectl patch deployment/k8ssandra-operator -n k8ssandra-operator --type json -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "k8ssandra-operator"},
  {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "1.1.1"}
]'
kubectl patch service/cass-operator-webhook-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cass-operator-webhook-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.port == 443) | index(true)')/appProtocol', "value": "tls"}
]'
kubectl patch service/cassandra-dc1-all-pods-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-all-pods-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "native") | index(true)')/appProtocol', "value": "tcp"}
]'
kubectl patch service/cassandra-dc1-all-pods-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-all-pods-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "mgmt-api") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/cassandra-dc1-all-pods-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-all-pods-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "prometheus") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/cassandra-dc1-reaper-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-reaper-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "app") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/cassandra-dc1-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "native") | index(true)')/appProtocol', "value": "tcp"}
]'
kubectl patch service/cassandra-dc1-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "mgmt-api") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/cassandra-dc1-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "prometheus") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/cassandra-dc1-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "thrift") | index(true)')/appProtocol', "value": "tcp"}
]'
kubectl patch service/cassandra-dc1-stargate-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-stargate-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "graphql") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/cassandra-dc1-stargate-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-stargate-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "authorization") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/cassandra-dc1-stargate-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-stargate-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "rest") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/cassandra-dc1-stargate-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-stargate-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "health") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/cassandra-dc1-stargate-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-stargate-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "metrics") | index(true)')/appProtocol', "value": "http"}
]'
kubectl patch service/cassandra-dc1-stargate-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service cassandra-dc1-stargate-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.name == "cassandra") | index(true)')/appProtocol', "value": "tcp"}
]'
kubectl patch service/k8ssandra-operator-webhook-service -n k8ssandra-operator --type json -p='[
  {"op": "replace", "path": '/spec/ports/$(kubectl get service k8ssandra-operator-webhook-service -n k8ssandra-operator -o json  | jq '.spec.ports | map(.port == 443) | index(true)')/appProtocol', "value": "tls"}
]'