wget https://github.com/etcd-io/etcd/archive/refs/tags/v3.5.4.tar.gz && tar -xvf v3.5.4.tar.gz && rm v3.5.4.tar.gz

https://github.com/improbable-eng/etcd-cluster-operator

cd ./etcd

wget https://github.com/improbable-eng/etcd-cluster-operator/archive/refs/tags/v0.2.0.tar.gz && tar -xvf v0.2.0.tar.gz && rm v0.2.0.tar.gz

cd ./etcd-cluster-operator

export GOPROXY=direct
docker build . --tag=k8s-lb:5000/improbable/etcd-cluster-operator:v0.2.0.1
docker push k8s-lb:5000/improbable/etcd-cluster-operator:v0.2.0.1

make install
make deploy

kubectl apply -f ./etcdCluster.yaml