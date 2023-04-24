wget https://github.com/projectcalico/calico/releases/download/v3.24.5/release-v3.24.5.tgz && tar -xvf release-v3.24.5.tgz && rm release-v3.24.5.tgz && rm -rf ./release-v3.24.5/images

wget https://github.com/projectcalico/calico/archive/refs/tags/v3.24.5.tar.gz && tar -xvf v3.24.5.tar.gz && rm v3.24.5.tar.gz

./cluster/setup-kind-multicluster.sh --kind-worker-nodes 1

kubectl patch deployment/coredns \
  -n kube-system \
  --type merge \
  --patch-file ./cluster/coredns-patch.yaml

kubectl apply -f ./cluster/release-v3.22.1/manifests/tigera-operator.yaml

kubectl apply -f ./cluster/calico-custom-resources.yaml

sudo cp ./cluster/calicoAPIConfig.yaml /etc/calico/calicoctl.cfg

watch kubectl get pods -n calico-system

kubectl taint nodes --all node-role.kubernetes.io/master-

docker network create \
  --driver=bridge \
  --subnet=10.244.0.0/16 \
  --gateway=10.244.0.1 \
  kind

kubectl apply -f ./cluster/monitoring/kube-tracing.yaml

https://github.com/cert-manager/cert-manager/issues/2640#issuecomment-601872165
kubectl exec -n kube-system kube-apiserver-k8s-0-control-plane -- env | grep -i proxy

kubectl exec -it $(kubectl get pods -n kube-system| grep kube-apiserver|awk '{print $1}') -n kube-system -- /bin/sh
kubectl exec -it $(kubectl get pods -n kube-system| grep kube-apiserver|awk '{print $1}') -n kube-system -h | grep enable-admission-plugins
kubectl exec -it kube-apiserver-k8s-0-control-plane -n kube-system -- kube-apiserver -h | grep -i proxy

curl -L https://github.com/projectcalico/calico/releases/download/v3.25.0/calicoctl-linux-amd64 -o calicoctl
chmod +x ./calicoctl
sudo mv calicoctl /usr/local/bin/

building calico:
make -C app-policy image
docker tag dikastes:latest-amd64 localhost:5000/calico/dikastes:v3.24.5.1
docker push localhost:5000/calico/dikastes:v3.24.5.1