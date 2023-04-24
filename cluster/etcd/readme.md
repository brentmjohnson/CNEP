https://gist.github.com/pyaillet/98305eac43af403deaff7b0ff38e276a

kubectl create secret generic etcd-creds --from-file=./cluster/etcd/ca.crt --from-file=./cluster/etcd/apiserver-etcd-client.crt --from-file=./cluster/etcd/apiserver-etcd-client.key

kubectl describe secret etcd-creds

kubectl apply -f ./cluster/etcd/etcd-client.yaml

etcdctl --endpoints http://etcd-cluster.ingress-apisix.svc.cluster.local:2379 get / --prefix --keys-only

etcdctl --endpoints http://etcd-cluster.ingress-apisix.svc.cluster.local:2379 del /apisix/ssls/1094c883
etcdctl --endpoints http://etcd-cluster.ingress-apisix.svc.cluster.local:2379 add /apisix/ssls/

curl --cacert /usr/local/apisix/conf/ssl/ca.crt --cert /etcd-ssl/apiserver-etcd-client.crt --key /etcd-ssl/apiserver-etcd-client.key https://k8s-control-0:2379/health

curl --cacert /usr/local/apisix/conf/ssl/ca.crt --cert /etcd-ssl/apiserver-etcd-client.crt --key /etcd-ssl/apiserver-etcd-client.key https://etcd.kube-system.svc.cluster.local:2379/health

curl --cacert /usr/local/apisix/conf/ssl/ca.crt --cert /etcd-ssl/apiserver-etcd-client.crt --key /etcd-ssl/apiserver-etcd-client.key https://172.18.0.3:2379/health

curl --cacert /etc/ssl/etcd-connect/ca.crt  --cert /etc/ssl/etcd-connect/apiserver-etcd-client.crt --key /etc/ssl/etcd-connect/apiserver-etcd-client.key https://k8s-0-control-plane:2379/health

etcdctl --cacert=/etc/ssl/etcd-connect/ca.crt --cert=/etc/ssl/etcd-connect/apiserver-etcd-client.crt --key=/etc/ssl/etcd-connect/apiserver-etcd-client.key --debug=true --endpoints https://k8s-control-2:2379 endpoint status

etcdctl --cacert=/etc/ssl/etcd-connect/ca.crt --cert=/etc/ssl/etcd-connect/apiserver-etcd-client.crt --key=/etc/ssl/etcd-connect/apiserver-etcd-client.key --debug=true --endpoints https://k8s-control-2:2379 member list

etcdctl \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
member list

https://github.com/etcd-io/etcd/issues/11970#issuecomment-687875315

openssl x509 -in ./cluster/etcd/ca.crt -text

openssl x509 -in ./cluster/etcd/apiserver-etcd-client.crt -text

openssl x509 -text -noout -in /etc/kubernetes/pki/etcd/server.crt
openssl x509 -text -noout -in /etc/kubernetes/pki/etcd/peer.crt

openssl x509 -text -noout -in ./cluster/etcd/apiserver-etcd-client.crt
openssl x509 -text -noout -in ./cluster/etcd/new-apiserver-etcd-client.crt
openssl x509 -text -noout -in ./cluster/etcd/sample-nocn-client.crt

/etc/kubernetes/pki/etcd/server.crt
/etc/kubernetes/pki/etcd/server.key
/etc/kubernetes/pki/etcd/peer.crt
/etc/kubernetes/pki/etcd/peer.key
/etc/kubernetes/pki/etcd/ca.crt

openssl genrsa -out ./cluster/etcd/new-apiserver-etcd-client.key 2048
ssh-keygen -p -m PEM -f ./cluster/etcd/new-apiserver-etcd-client.key

openssl req -new -key ./cluster/etcd/new-apiserver-etcd-client.key -out ./cluster/etcd/new-apiserver-etcd-client.csr \
    -subj '/O=system:masters' \
    -addext keyUsage=critical,digitalSignature,keyEncipherment \
    -addext "extendedKeyUsage=clientAuth" \
    -addext basicConstraints=critical,CA:FALSE

openssl req -noout -text  -in ./cluster/etcd/new-apiserver-etcd-client.csr

openssl x509 -req -days 365 -in ./cluster/etcd/new-apiserver-etcd-client.csr -CA ./cluster/etcd/ca.crt \
-CAkey ./cluster/etcd/ca.key -set_serial 01 -out ./cluster/etcd/new-apiserver-etcd-client.crt \
    -copy_extensions copy \
    -ext "keyUsage,extendedKeyUsage,basicConstraints"

https://kubernetes.io/docs/setup/best-practices/certificates/