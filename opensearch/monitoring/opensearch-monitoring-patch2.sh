kubectl patch service/opensearch-discovery -n opensearch-operator-system --type json -p='[
   {"op": "replace", "path": "/spec/ports", "value": [
      {
         "name": "http",
         "protocol": "TCP",
         "appProtocol": "http",
         "port": 9200,
         "targetPort": 9200
      },
      {
         "name": "transport",
         "protocol": "TCP",
         "appProtocol": "tls",
         "port": 9300,
         "targetPort": 9300
      }
   ]}
]'