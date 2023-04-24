kubectl patch deployment apisix -n ingress-apisix --type json -p='[{"op": "replace", "path": "/spec/template/spec/initContainers/0/command/2", "value":"until nc -z apisix-etcd-headless.ingress-apisix.svc.cluster.local 2379; do echo waiting for etcd `date`; sleep 2; done;"}]'

kubectl patch deployment apisix -n ingress-apisix --type json -p='[{"op": "replace", "path": "/spec/template/spec/initContainers/0/command/2", "value":"until nc -z apisix-etcd.ingress-apisix.svc 2379; do echo waiting for etcd `date`; sleep 2; done;"}]'

kubectl patch deployment apisix -n ingress-apisix --type json -p='[{"op": "replace", "path": "/spec/template/spec/initContainers/0/command/2", "value":"until nc -z apisix-etcd.ingress-apisix.svc.cluster.local 2379; do echo waiting for etcd `date`; sleep 2; done;"}]'

kubectl exec -it -n ${namespace of Apache APISIX} ${Pod name of Apache APISIX} -- curl http://127.0.0.1:9180/apisix/admin/routes -H 'X-API-Key: edd1c9f034335f136f87ad84b625c8f1'

helm uninstall apisix apisix/apisix
helm uninstall apisix-dashboard apisix/apisix-dashboard