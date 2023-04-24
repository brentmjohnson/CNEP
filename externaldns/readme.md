1. helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
helm repo update external-dns
helm upgrade -i external-dns external-dns/external-dns \
  --version 1.12.0 \
  --namespace external-dns \
  --values ./externaldns/helm/values/external-dns-values.yaml \
  --debug \
  --dry-run \
  > ./externaldns/helm/helm.yaml