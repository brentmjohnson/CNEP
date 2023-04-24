https://www.kubegres.io/doc/getting-started.html

kubectl apply -f https://raw.githubusercontent.com/reactive-tech/kubegres/v1.15/kubegres.yaml

kubectl apply -f my-postgres-secret.yaml

kubectl apply -f my-backup-pvc.yaml

kubectl apply -f my-postgres.yaml

kubectl -n kubegres-system port-forward svc/mypostgres 5432 &

kubectl -n kubegres-system port-forward svc/kubegres-controller-manager-metrics-service 8443 &