kubectl apply -f \
https://projectcalico.docs.tigera.io/security/tutorials/app-layer-policy/manifests/10-yaobank.yaml

kubectl get pods

kubectl get services

kubectl port-forward svc/customer 8080:80 &
kubectl port-forward customer-6db9b448c9-vxvpv 8080:8000 &

kubectl exec -ti customer-6db9b448c9-vxvpv -c customer -- bash
kubectl exec -ti summary-869fd664ff-6pk2l -c summary -- bash

curl http://database:2379/v2/keys?recursive=true | python -m json.tool
curl -I http://database:2379/v2/keys?recursive=true

curl -O https://projectcalico.docs.tigera.io/security/tutorials/app-layer-policy/manifests/30-policy.yaml
calicoctl create -f ./cluster/30-policy.yaml
