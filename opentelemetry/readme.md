https://github.com/open-telemetry/opentelemetry-operator

kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml

kubectl apply -f ./opentelemetry/collector.yaml

kubectl apply -f ./opentelemetry/monitoring/daemonset-collector-monitoring-podMonitor.yaml

echo '[
  {
    "traceId": "5982fe77008310cc80f1da5e10147519",
    "parentId": "90394f6bcffb5d13",
    "id": "67fae42571535f60",
    "kind": "SERVER",
    "name": "/m/n/2.6.1",
    "timestamp": 1516781775726000,
    "duration": 26000,
    "localEndpoint": {
      "serviceName": "api"
    },
    "remoteEndpoint": {
      "serviceName": "apip"
    },
    "tags": {
      "data.http_response_code": "201"
    }
  }
]' >> trace.json

curl -X POST 0.0.0.0:9411/api/v2/spans -H'Content-Type: application/json' -d @trace.json
curl -X POST 127.0.0.1:9411/api/v2/spans -H'Content-Type: application/json' -d @trace.json
curl -X POST localhost:9411/api/v2/spans -H'Content-Type: application/json' -d @trace.json
curl -X POST zipkin.opentelemetry.cluster.local:9411/api/v2/spans -H'Content-Type: application/json' -d @trace.json
curl -X POST daemonset-collector.opentelemetry-operator-system:9411/api/v2/spans -H'Content-Type: application/json' -d @trace.json
curl -X POST daemonset-collector.opentelemetry-operator-system.svc.cluster.local:9411 -H'Content-Type: application/json' -d @trace.json
curl -X POST 172-18-0-3.daemonset-collector.opentelemetry-operator-system.svc.cluster.local:9411 -H'Content-Type: application/json' -d @trace.json