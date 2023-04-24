kubectl patch --type merge \
  --filename ./monitoring/loki/monitoring/loki-loki-distributed-distributor-serviceMonitor-patch.yaml \
  --patch-file ./monitoring/loki/monitoring/loki-loki-distributed-distributor-serviceMonitor-patch.yaml

kubectl patch --type merge \
  --filename ./monitoring/loki/monitoring/loki-loki-distributed-ingester-serviceMonitor-patch.yaml \
  --patch-file ./monitoring/loki/monitoring/loki-loki-distributed-ingester-serviceMonitor-patch.yaml

kubectl patch --type merge \
  --filename ./monitoring/loki/monitoring/loki-loki-distributed-querier-serviceMonitor-patch.yaml \
  --patch-file ./monitoring/loki/monitoring/loki-loki-distributed-querier-serviceMonitor-patch.yaml

kubectl patch --type merge \
  --filename ./monitoring/loki/monitoring/loki-loki-distributed-query-frontend-serviceMonitor-patch.yaml \
  --patch-file ./monitoring/loki/monitoring/loki-loki-distributed-query-frontend-serviceMonitor-patch.yaml

kubectl patch --type merge \
  --filename ./monitoring/loki/monitoring/loki-loki-distributed-table-manager-serviceMonitor-patch.yaml \
  --patch-file ./monitoring/loki/monitoring/loki-loki-distributed-table-manager-serviceMonitor-patch.yaml