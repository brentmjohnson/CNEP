https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

wget https://github.com/kubernetes/dashboard/archive/refs/tags/v2.6.0.tar.gz && tar -xvf v2.6.0.tar.gz && rm v2.6.0.tar.gz

kubectl apply -f ./dashboard/dashboard-2.6.0/aio/deploy/recommended.yaml

kubectl apply -f ./dashboard/adminuser.yaml

kubectl apply -f clusterrolebinding.yaml

kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

kubectl proxy &

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

kubectl apply -f ./dashboard/apisixRoute.yaml
kubectl apply -f ./dashboard/apisixIngress.yaml

kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl "http://127.0.0.1:9180/apisix/admin/upstreams" -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1"

kubectl -n ingress-apisix exec -it $(kubectl get pods -n ingress-apisix -l app.kubernetes.io/name=apisix -o name) -- curl "http://127.0.0.1:9180/apisix/admin/upstreams/7dc55665" -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PATCH -d '
{
    "scheme": "https"
}'

docker network inspect kind

"Containers": {
    "02394deb7da085de090eeb902067ddf852afc2c686454927e07e0628a7fa7d8a": {
        "Name": "kind-registry",
        "EndpointID": "b2d3a40da49fd8a6534bf90d6ea2a9fe684a59b29768aca1fdbb33ea1dee8a38",
        "MacAddress": "02:42:ac:1f:00:04",
        "IPv4Address": "172.31.0.4/16",
        "IPv6Address": "fc00:f853:ccd:e793::4/64"
    },
    "6152d6e0f7785f2f40dec9d657da2a6fc776ecc1d8ff259dbd6d62b31a75de1e": {
        "Name": "k8s-0-worker",
        "EndpointID": "9e0f5f7d08d5c5cdb25510e927759a0189f431ecc5104bb29e881ed0eb75d76f",
        "MacAddress": "02:42:ac:1f:00:02",
        "IPv4Address": "172.31.0.2/16",
        "IPv6Address": "fc00:f853:ccd:e793::2/64"
    },
    "857d6fc741b7ee51a4e676f704d9928784f032141b3301a05c2d00c5c59e4331": {
        "Name": "k8s-0-control-plane",
        "EndpointID": "528873bdba7833827b9cba29fbc77acb0a20c93f9c64ae48d305052c816d6e59",
        "MacAddress": "02:42:ac:1f:00:03",
        "IPv4Address": "172.31.0.3/16",
        "IPv6Address": "fc00:f853:ccd:e793::3/64"
    }
}