sudo apt-get install jsonnet

go install -a github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@v0.5.1

jb init

jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@v0.12.0
jb install gitlab.com/uneeq-oss/cert-manager-mixin@master
jb install github.com/jaegertracing/jaeger/monitoring/jaeger-mixin@v1.41.0
jb install github.com/ceph/ceph/monitoring/ceph-mixin@v17.2.5

cp ../kube-prometheus-0.10.0/example.jsonnet example.jsonnet

cp ../kube-prometheus-0.10.0/build.sh build.sh

jb update

go install github.com/brancz/gojsontoyaml@v0.1.0

./build.sh

kubectl apply --server-side -f ./monitoring/my-kube-prometheus/manifests/setup
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl apply -f ./monitoring/my-kube-prometheus/manifests/ && \
kubectl patch deployment/prometheus-adapter -n monitoring --type json -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/args/4", "value": "--prometheus-url=http://prometheus-operated.monitoring.svc:9090/"}]'

kubectl --namespace monitoring port-forward svc/prometheus-operated 9090 &
kubectl --namespace monitoring port-forward svc/prometheus-grafana 3000 &
kubectl --namespace monitoring port-forward svc/alertmanager-operated 9093 &