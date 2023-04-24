1. cd downloads && curl -LO https://github.com/redpanda-data/redpanda/releases/download/v22.3.11/rpk-linux-amd64.zip
2. mkdir -p ~/.local/bin
<!-- 3. this should already exist in most cases
export PATH="~/.local/bin:$PATH" -->
4. unzip rpk-linux-amd64.zip -d ~/.local/bin/
5. rpk version
6. helm repo add redpanda https://charts.vectorized.io/ && \
helm repo update
7. 

curl https://raw.githubusercontent.com/redpanda-data/observability/main/grafana-dashboards/Kafka%20Consumer%20Offsets.json -o ./redpanda/monitoring/Kafka-Consumer-Offsets.json
curl https://raw.githubusercontent.com/redpanda-data/observability/main/grafana-dashboards/Kafka-Consumer-Metrics.json -o ./redpanda/monitoring/Kafka-Consumer-Metrics.json
curl https://raw.githubusercontent.com/redpanda-data/observability/main/grafana-dashboards/Kafka-Topic-Metrics.json -o ./redpanda/monitoring/Kafka-Topic-Metrics.json
curl https://raw.githubusercontent.com/redpanda-data/observability/main/grafana-dashboards/Redpanda-Default-Dashboard.json -o ./redpanda/monitoring/Redpanda-Default-Dashboard.json
curl https://raw.githubusercontent.com/redpanda-data/observability/main/grafana-dashboards/Redpanda-Ops-Dashboard.json -o ./redpanda/monitoring/Redpanda-Ops-Dashboard.json


kubectl exec -n redpanda statefulset/redpanda -- rpk acl create \
--allow-principal User:jaeger-admin --operation all --group jaeger-ingester \
--user redpanda --password pMUVoyUtA.W5bfFR.GIO

kubectl exec -n redpanda statefulset/redpanda -- rpk cluster config export \
--user redpanda --password pMUVoyUtA.W5bfFR.GIO

kubectl exec -n redpanda statefulset/redpanda -- rpk topic delete chat-rooms \
--user redpanda --password pMUVoyUtA.W5bfFR.GIO

kubectl exec -n redpanda statefulset/redpanda -- rpk topic describe chat-rooms \
--user redpanda --password pMUVoyUtA.W5bfFR.GIO

kubectl exec -n redpanda statefulset/redpanda -- rpk cluster metadata \
--user redpanda --password pMUVoyUtA.W5bfFR.GIO

kubectl exec -it -n scylla statefulset/scylla-dc-default -- \
cqlsh localhost -u scylla -p 9RTzJHR3x1xHU2Rk_8yP \
-e "DROP ROLE'jaeger-admin';"

kubectl exec -it -n scylla statefulset/scylla-dc-default -- \
cqlsh localhost -u scylla -p 9RTzJHR3x1xHU2Rk_8yP \
--no-color \
-e "SELECT COUNT(*) FROM system_schema.tables WHERE keyspace_name = 'jaeger';" \
| awk -F\, 'NR>3' \
| head -n -2 \
| awk '{print $1}'

https://github.com/redpanda-data/redpanda/blob/dev/src/go/k8s/config/crd/bases/redpanda.vectorized.io_clusters.yaml
https://docs.redpanda.com/docs/reference/redpanda-operator/kubernetes-additional-config/
https://docs.redpanda.com/docs/reference/cluster-properties/
https://docs.redpanda.com/docs/21.11/reference/rpk-commands/#rpk-topic-describe