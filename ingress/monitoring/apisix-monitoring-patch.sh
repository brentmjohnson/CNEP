# kubectl patch deployment/apisix -n ingress-apisix --type json -p='[
#   {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "apisix"},
#   {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "2.14.1"}
# ]'
# kubectl patch deployment/apisix-ingress-controller -n ingress-apisix --type json -p='[
#   {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "apisix-ingress-controller"},
#   {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "1.4.1"}
# ]'
# kubectl patch deployment/apisix-dashboard -n ingress-apisix --type json -p='[
#   {"op": "add", "path": "/spec/template/metadata/labels/app", "value": "apisix-dashboard"},
#   {"op": "add", "path": "/spec/template/metadata/labels/version", "value": "2.13"}
# ]'
# kubectl patch service/apisix-admin -n ingress-apisix --type json -p='[
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service apisix-admin -n ingress-apisix -o json  | jq '.spec.ports | map(.name == "apisix-admin") | index(true)')/appProtocol', "value": "http"}
# ]'
# kubectl patch service/apisix-gateway -n ingress-apisix --type json -p='[
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service apisix-gateway -n ingress-apisix -o json  | jq '.spec.ports | map(.name == "apisix-gateway") | index(true)')/appProtocol', "value": "http"}
# ]'
# kubectl patch service/apisix-gateway -n ingress-apisix --type json -p='[
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service apisix-gateway -n ingress-apisix -o json  | jq '.spec.ports | map(.name == "apisix-gateway-tls") | index(true)')/appProtocol', "value": "tls"}
# ]'
# kubectl patch service/apisix-gateway -n ingress-apisix --type json -p='[
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service apisix-gateway -n ingress-apisix -o json  | jq '.spec.ports | map(.name == "proxy-tcp-0") | index(true)')/appProtocol', "value": "tcp"}
# ]'
# kubectl patch service/apisix-gateway -n ingress-apisix --type json -p='[
#   {"op": "replace", "path": '/spec/ports/$(kubectl get service apisix-gateway -n ingress-apisix -o json  | jq '.spec.ports | map(.name == "proxy-tcp-1") | index(true)')/appProtocol', "value": "tcp"}
# ]'
kubectl patch service/apisix-admin -n ingress-apisix --type json -p='[
  {"op": "add", "path": "/spec/ports/-", "value": {
      "name": "prometheus",
      "protocol": "TCP",
      "appProtocol": "http",
      "port": 9091,
      "targetPort": 9091
    }
  }
]'
kubectl patch serviceMonitor/apisix -n ingress-apisix --type json -p='[
  {"op": "replace", "path": "/spec/selector/matchLabels/app.kubernetes.io~1service", "value": "apisix-admin"},
  {"op": "replace", "path": "/spec/endpoints/0/scheme", "value": "https"},
  {"op": "replace", "path": "/spec/endpoints/0/tlsConfig", "value": {
      "caFile": "/etc/prom-certs/root-cert.pem",
      "certFile": "/etc/prom-certs/cert-chain.pem",
      "insecureSkipVerify": true,
      "keyFile": "/etc/prom-certs/key.pem"
    }
  }
]'
kubectl patch serviceMonitor/apisix-ingress-controller -n ingress-apisix --type json -p='[
  {"op": "replace", "path": "/spec/endpoints/0/scheme", "value": "https"},
  {"op": "replace", "path": "/spec/endpoints/0/tlsConfig", "value": {
      "caFile": "/etc/prom-certs/root-cert.pem",
      "certFile": "/etc/prom-certs/cert-chain.pem",
      "insecureSkipVerify": true,
      "keyFile": "/etc/prom-certs/key.pem"
    }
  }
]'