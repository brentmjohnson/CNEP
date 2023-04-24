1. scp ./hyper-v/kubeadm-config-control.yaml 10.0.0.3:/tmp
2. sudo kubeadm upgrade diff --config /tmp/kubeadm-config-control.yaml
3. kubectl drain k8s-0-control-0 --ignore-daemonsets
4. sudo kubeadm upgrade apply --config /tmp/kubeadm-config-control.yaml --ignore-preflight-errors=NumCPU,Mem,Swap
5. kubectl uncordon k8s-0-control-0

1. scp ./hyper-v/kubeadm-config-worker.yaml 10.0.0.6:/tmp
2. sudo kubeadm upgrade node diff --config /tmp/kubeadm-config-worker.yaml
3. kubectl drain k8s-0-worker-0 --ignore-daemonsets --delete-emptydir-data
4. sudo kubeadm upgrade node --ignore-preflight-errors=NumCPU,Mem,Swap
5. kubectl uncordon k8s-0-worker-0

1. sudo kubeadm certs renew all

kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=k8s-0-worker-1
kubectl get pods -n kafka -o wide --field-selector spec.nodeName=k8s-0-worker-1

kubectl drain k8s-0-worker-1 --ignore-daemonsets --delete-emptydir-data --force