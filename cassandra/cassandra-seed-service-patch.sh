kubectl patch service/cassandra-seed-service -n k8ssandra-operator --type json -p='[
   {"op": "replace", "path": "/spec/ports", "value": [
      {
         "name": "internode",
         "protocol": "TCP",
         "appProtocol": "tcp",
         "port": 7000,
         "targetPort": 7000
      },
      {
         "name": "tls-internode",
         "protocol": "TCP",
         "appProtocol": "tls",
         "port": 7001,
         "targetPort": 7001
      },
      {
         "name": "jmx",
         "protocol": "TCP",
         "appProtocol": "tcp",
         "port": 7199,
         "targetPort": 7199
      }
   ]}
]'