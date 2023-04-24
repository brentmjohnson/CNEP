wget https://github.com/kubernetes-sigs/metrics-server/archive/refs/tags/metrics-server-helm-chart-3.8.2.tar.gz && tar -xvf metrics-server-helm-chart-3.8.2.tar.gz && rm metrics-server-helm-chart-3.8.2.tar.gz

kustomize build ./metricsserver/metrics-server-metrics-server-helm-chart-3.8.2/manifests/release | kubectl apply --server-side -f -

https://github.com/kubernetes-sigs/kind/issues/398#issuecomment-478311167

@hjacobs
please add this flags to your metric-deployment

    args:
        - --kubelet-insecure-tls
        - --kubelet-preferred-address-types=InternalIP

kubectl patch Deployment/metrics-server -n kube-system --type json -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

kubectl top pods --all-namespaces --sort-by=memory