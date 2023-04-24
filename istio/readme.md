https://projectcalico.docs.tigera.io/security/app-layer-policy

calicoctl get nodes

calicoctl patch FelixConfiguration default --patch \
   '{"spec": {"policySyncPathPrefix": "/var/run/nodeagent"}}'

wget https://github.com/istio/istio/archive/refs/tags/1.16.1.tar.gz && tar -xvf 1.16.1.tar.gz && rm 1.16.1.tar.gz

https://istio.io/v1.9/docs/ops/diagnostic-tools/istioctl/

<!-- 1.10.2 -->
curl -sL https://istio.io/downloadIstioctl | ISTIO_VERSION=1.10.2 sh -
curl -sL https://istio.io/downloadIstioctl | ISTIO_VERSION=1.16.1 sh -

istioctl upgrade -f ./istio/istioOperator.yaml

istioctl x precheck

istioctl operator init

  <!-- components:
    ingressGateways:
    - enabled: false -->

kubectl apply -f - <<EOF
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  namespace: istio-system
  name: istiocontrolplane
spec:
  profile: default
  components:
    ingressGateways:
    - name: istio-ingressgateway
      enabled: false
    egressGateways:
    - name: istio-egressgateway
      enabled: true
    pilot:
      enabled: true
EOF

kubectl create -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default-strict-mode
  namespace: istio-system
spec:
  mtls:
    mode: STRICT
EOF

kubectl -n istio-system get PeerAuthentication -o yaml

kubectl patch configmap -n istio-system istio-sidecar-injector --patch "$(cat ./cluster/release-v3.22.2/manifests/alp/istio-inject-configmap-1.10.yaml)"

kubectl apply -f ./cluster/release-v3.22.2/manifests/alp/istio-app-layer-policy-envoy-v3.yaml

kubectl label namespace default istio-injection=enabled --overwrite

kubectl apply -f https://projectcalico.docs.tigera.io/security/tutorials/app-layer-policy/manifests/10-yaobank.yaml

kubectl exec -ti customer-bf7799f8f-dl7jk -c customer -- bash

calicoctl create -f https://projectcalico.docs.tigera.io/security/tutorials/app-layer-policy/manifests/30-policy.yaml

kubectl apply -f ./istio/default-telemetry.yaml

kubectl apply -f ./istio/opentelemetry-zipkin-sidecar.yaml

kubectl apply -f ./istio/opentelemetry-zipkin-external.yaml

kubectl apply -f ./istio/opentelemetry-zipkin-destination.yaml

istioctl proxy-config log debug.default --level=debug

kubectl port-forward -n istio-system svc/kiali 20001 &

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.14/samples/bookinfo/platform/kube/bookinfo.yaml

curl http://productpage:9080/productpage -v
for i in $(seq 1 10000); do curl -s -o /dev/null "http://productpage:9080/productpage"; done

kubectl get configmap -n istio-system istio-sidecar-injector -o yaml >> ./istio/istio-inject-configmap.yaml