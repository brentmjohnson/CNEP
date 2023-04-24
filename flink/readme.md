https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-main/docs/try-flink-kubernetes-operator/quick-start/

wget https://github.com/apache/flink-kubernetes-operator/archive/refs/tags/release-1.3.1.tar.gz && tar -xvf release-1.3.1.tar.gz && rm release-1.3.1.tar.gz

wget https://github.com/apache/flink-kubernetes-operator/archive/refs/tags/release-1.3.1.tar.gz && tar -xvf release-1.3.1.tar.gz && rm release-1.3.1.tar.gz

wget https://downloads.apache.org/flink/flink-kubernetes-operator-0.1.0/flink-kubernetes-operator-0.1.0-helm.tgz && tar -xvf flink-kubernetes-operator-0.1.0-helm.tgz && rm flink-kubernetes-operator-0.1.0-helm.tgz

wget https://downloads.apache.org/flink/flink-kubernetes-operator-0.1.0/flink-kubernetes-operator-0.1.0-src.tgz && tar -xvf flink-kubernetes-operator-0.1.0-src.tgz && rm flink-kubernetes-operator-0.1.0-src.tgz

kubectl create namespace flink



helm repo add flink-operator-repo https://downloads.apache.org/flink/flink-kubernetes-operator-0.1.0/
helm install flink-kubernetes-operator flink-operator-repo/flink-kubernetes-operator --namespace flink

kubectl apply -f ./flink/basic.yaml

kubectl patch configmap/flink-config-basic-example \
  -n flink \
  --type merge \
  --patch-file ./flink/flink-config-basic-example-patch.yaml

kubectl rollout restart -n flink deployment basic-example

kubectl -n flink port-forward svc/basic-example-rest 8081 &

kubectl apply -f ./flink/apisixRoute.yaml

kubectl apply -f ./flink/apisixIngress.yaml

