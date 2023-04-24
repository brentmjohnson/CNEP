https://github.com/fluent/fluent-operator#install
# fluentbit
1. kubectl create namespace fluent
2. helm upgrade -i fluent-operator https://github.com/fluent/fluent-operator/releases/download/v1.1.0/fluent-operator.tgz \
  --namespace fluent \
  --set Kubernetes=true \
  --set containerRuntime=docker \
  --debug \
  --dry-run \
  > ./fluent/helm.yaml
3. kubectl apply -f ./fluent/fluent-forward.yaml
4. kubectl apply -f ./fluent/kubernetes-cluster-filter.yaml
5. kubectl apply -f ./fluent/tail-input.yaml