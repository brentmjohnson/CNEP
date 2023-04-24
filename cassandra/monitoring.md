https://github.com/k8ssandra/k8ssandra-operator/blob/0bc61ef1ce9f89571cc935d677630738b44dad15/docs/prometheus-grafana/prometheus-installation-configuration.md

https://github.com/k8ssandra/k8ssandra-operator/blob/0bc61ef1ce9f89571cc935d677630738b44dad15/docs/prometheus-grafana/grafana-configuration.md

https://github.com/datastax/metric-collector-for-apache-cassandra

kubectl patch clusterrole/prometheus-k8s --type json -p='[ { "op": "add", "path": "/rules/-", "value": { "verbs": [ "get", "list", "watch" ], "apiGroups": [ "" ], "resources": [ "pods", "endpoints", "services" ] } } ]'

wget https://github.com/datastax/metric-collector-for-apache-cassandra/releases/download/v0.3.1/datastax-mcac-dashboards-0.3.1.tar.gz && tar -xvf datastax-mcac-dashboards-0.3.1.tar.gz && rm datastax-mcac-dashboards-0.3.1.tar.gz

