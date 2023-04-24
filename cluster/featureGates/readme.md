https://faun.pub/feature-gates-how-to-enable-kubernetes-alpha-features-fdb38dc3a9aa

root@k8s-0-control-plane:/# ls -l /etc/kubernetes/manifests/

docker cp k8s-0-control-plane:/etc/kubernetes/manifests/kube-apiserver.yaml ./cluster/featureGates/
docker cp k8s-0-control-plane:/etc/kubernetes/manifests/kube-controller-manager.yaml ./cluster/featureGates/
docker cp k8s-0-control-plane:/etc/kubernetes/manifests/kube-scheduler.yaml ./cluster/featureGates/

docker cp ./cluster/featureGates/kube-apiserver-patch.yaml k8s-0-control-plane:/etc/kubernetes/manifests/kube-apiserver.yaml
docker cp ./cluster/featureGates/kube-controller-manager-patch.yaml k8s-0-control-plane:/etc/kubernetes/manifests/kube-controller-manager.yaml
docker cp ./cluster/featureGates/kube-scheduler-patch.yaml k8s-0-control-plane:/etc/kubernetes/manifests/kube-scheduler.yaml
docker cp ./cluster/featureGates/tracing-config.yaml k8s-0-control-plane:/etc/kubernetes/manifests/