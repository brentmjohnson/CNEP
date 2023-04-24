https://github.com/k8ssandra/k8ssandra-operator/blob/0bc61ef1ce9f89571cc935d677630738b44dad15/docs/prometheus-grafana/prometheus-installation-configuration.md

wget https://github.com/prometheus-operator/kube-prometheus/archive/refs/tags/v0.12.0.tar.gz && tar -xvf v0.12.0.tar.gz && rm v0.12.0.tar.gz
wget https://github.com/prometheus-operator/kube-prometheus/archive/refs/heads/main.zip && unzip main.zip && rm main.zip

kubectl apply --server-side -f ./monitoring/kube-prometheus-0.10.0/manifests/setup
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl apply -f ./monitoring/kube-prometheus-0.10.0/manifests/

kubectl patch Alertmanager/main -n monitoring --type json -p='[{"op": "replace", "path": "/spec/replicas", "value": 1}]'
kubectl patch Prometheus/k8s -n monitoring --type json -p='[{"op": "replace", "path": "/spec/replicas", "value": 1}]'
kubectl patch deployment/prometheus-adapter -n monitoring --type json -p='[
    {"op": "replace", "path": "/spec/replicas", "value": 1},
    {"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--prometheus-url=http://prometheus-operated.monitoring.svc:9090/"}
]'

https://github.com/prometheus-operator/kube-prometheus/issues/1648
url: "http://prometheus-operated.monitoring.svc:9090"

export DATASOURCE=$(echo '{
    "apiVersion": 1,
    "datasources": [
        {
            "access": "proxy",
            "editable": false,
            "name": "prometheus",
            "orgId": 1,
            "type": "prometheus",
            "url": "http://prometheus-operated.monitoring.svc:9090",
            "version": 1
        }
    ]
}' | base64 | tr -d '\n')
echo $DATASOURCE
echo $DATASOURCE | base64 -d
kubectl patch secret/grafana-datasources -n monitoring --type json -p='[{"op": "replace", "path": "/data/datasources.yaml", "value": <secret>}]'
kubectl rollout restart -n monitoring deployment grafana

https://github.com/prometheus-operator/kube-prometheus/issues/1510#issuecomment-1035176332

export CONFIG=$(echo '[date_formats]
default_timezone = UTC

[server]
serve_from_sub_path = true
root_url = http://localhost:31736/grafana/' | base64 | tr -d '\n')
echo $CONFIG
echo $CONFIG | base64 -d
kubectl patch secret/grafana-config -n monitoring --type json -p='[{"op": "replace", "path": "/data/grafana.ini", "value": <secret>}]'
kubectl rollout restart -n monitoring deployment grafana


kubectl apply -f ./monitoring/kube-scheduler-serviceMonitor.yaml
kubectl apply -f ./monitoring/kube-scheduler-service.yaml
kubectl apply -f ./monitoring/kube-controller-manager-serviceMonitor.yaml
kubectl apply -f ./monitoring/kube-controller-manager-service.yaml
kubectl apply -f ./monitoring/kube-proxy-podMonitor.yaml

https://github.com/prometheus-community/helm-charts/pull/889/files
https://github.com/prometheus-operator/kube-prometheus/issues/1026

kubectl --namespace monitoring port-forward svc/prometheus-k8s 9090 &
kubectl --namespace monitoring port-forward svc/grafana 3000 &
kubectl --namespace monitoring port-forward svc/alertmanager-main 9093 &

http://localhost:9090
http://localhost:3000 admin:admin
http://localhost:9093

kubectl delete --ignore-not-found=true -f ./monitoring/kube-prometheus-main/manifests/ -f ./monitoring/kube-prometheus-main/manifests/setup
# remove the CRD finalizer blocking on custom resource cleanup
kubectl patch crd/opensearchclusters.opensearch.opster.io -p '{"metadata":{"finalizers":[]}}' --type=merge