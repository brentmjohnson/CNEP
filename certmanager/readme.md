wget https://gitlab.com/uneeq-oss/cert-manager-mixin/-/archive/master/cert-manager-mixin-master.tar.gz && tar -xvf cert-manager-mixin-master.tar.gz && rm cert-manager-mixin-master.tar.gz


$ kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.yaml

openssl x509 -in ca.crt -text -noout

# caching letsencrypt certs
1. account keys:
kubectl get secrets -n cert-manager letsencrypt-example-account-key -o yaml > certmanager/kustomize/cert-manager-letsencrypt-issuer/base/letsencrypt-example-account-key.yaml
kubectl get secrets -n cert-manager letsencrypt-staging-example-account-key -o yaml > certmanager/kustomize/cert-manager-letsencrypt-issuer/base/letsencrypt-staging-example-account-key.yaml
% can be excluded: https://cert-manager.io/docs/tutorials/backup/#restoring-ingress-certificates
2. certs:
kubectl get certificates -n ingress-apisix apisix-letsencrypt-cert -o yaml > certmanager/kustomize/cert-manager-letsencrypt-issuer/base/apisix-letsencrypt-cert.yaml
kubectl get certificates -n ingress-apisix apisix-internal-letsencrypt-cert -o yaml > certmanager/kustomize/cert-manager-letsencrypt-issuer/base/apisix-internal-letsencrypt-cert.yaml
kubectl get certificates -n default httpbin-letsencrypt-cert -o yaml > certmanager/kustomize/cert-manager-letsencrypt-issuer/base/httpbin-letsencrypt-cert.yaml
5. secrets:
kubectl get secrets -n ingress-apisix apisix-letsencrypt-cert -o yaml > certmanager/kustomize/cert-manager-letsencrypt-issuer/base/apisix-letsencrypt-cert-secret.yaml
kubectl get secrets -n ingress-apisix apisix-internal-letsencrypt-cert -o yaml > certmanager/kustomize/cert-manager-letsencrypt-issuer/base/apisix-internal-letsencrypt-cert-secret.yaml
kubectl get secrets -n default httpbin-letsencrypt-cert -o yaml > certmanager/kustomize/cert-manager-letsencrypt-issuer/base/httpbin-letsencrypt-cert-secret.yaml

backup:
kubectl get certificates -A -o yaml | yq '.items | map(select(.spec.issuerRef.group == "cert-manager.io" and .spec.issuerRef.name == "letsencrypt") | [.metadata.namespace,.spec.secretName])' -o=tsv |
while read -r fname
do echo $fname
done

kubectl get certificates -A -o yaml | yq '.items | map(select(.spec.issuerRef.group == "cert-manager.io" and .spec.issuerRef.name == "letsencrypt") | [.metadata.namespace,.spec.secretName])' -o=tsv |
while read -r fname
do echo --- && kubectl get secret -n $fname -o yaml;
done > certmanager/kustomize/cert-manager-letsencrypt-issuer/cache/secrets.yaml

kubectl get certificates -A -o yaml | yq '.items | map(select(.spec.issuerRef.group == "cert-manager.io" and .spec.issuerRef.name == "letsencrypt" and .metadata.ownerReferences[].kind != "Ingress")) | .[] | split_doc' > certmanager/kustomize/cert-manager-letsencrypt-issuer/cache/certificates.yaml


while read -r fname; do kubectl get secret -n $fname -o yaml && echo ---; done <<< `kubectl get certificates -A -o yaml | yq '.items | map(select(.spec.issuerRef.group == "cert-manager.io" and .spec.issuerRef.name == "letsencrypt") | [.metadata.namespace,.spec.secretName])' -o=tsv`

kubectl get certificates -A -o yaml | yq '.items | map(select(.spec.issuerRef.name == "letsencrypt" and .metadata.ownerReferences[].kind == "Ingress"))'
kubectl get certificates -A -o yaml | yq '.items | map(select(.spec.issuerRef.name == "letsencrypt" and .metadata.ownerReferences[].kind != "Ingresss")) | .[] | split_doc'