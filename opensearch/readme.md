https://github.com/Opster/opensearch-k8s-operator

wget https://github.com/Opster/opensearch-k8s-operator/archive/refs/heads/main.zip && unzip main.zip && rm main.zip

wget https://github.com/Opster/opensearch-k8s-operator/archive/refs/tags/opensearch-operator-1.0.3.tar.gz && tar -xvzf opensearch-operator-1.0.3.tar.gz && rm opensearch-operator-1.0.3.tar.gz

wget https://github.com/Opster/opensearch-k8s-operator/archive/refs/tags/v1.1.tar.gz && tar -xvzf v1.1.tar.gz && rm v1.1.tar.gz

wget https://github.com/Opster/opensearch-k8s-operator/archive/refs/tags/v2.0.tar.gz && tar -xvzf v2.0.tar.gz && rm v2.0.tar.gz

wget https://github.com/Opster/opensearch-k8s-operator/releases/download/v0.9/opensearchOperator-chart.tar.gz && tar -xvzf opensearchOperator-chart.tar.gz && rm opensearchOperator-chart.tar.gz

kubectl create namespace opensearch-operator-system 

helm install opensearch-operator ./opensearch/opensearch-k8s-operator-0.9/charts \
-f ./opensearch/opensearch-operator.yaml \

cd ./opensearch/opensearch-k8s-operator-main/opensearch-operator/
go env -w GOPATH=/home/<user>/dataStore/opensearch/opensearch-k8s-operator-main/opensearch-operator/bin
go env -w GOBIN=/home/<user>/dataStore/opensearch/opensearch-k8s-operator-main/opensearch-operator/bin
make controller-gen
make kustomize
find ./ -iname controller-gen
find ./ -iname kustomize
cd ./bin
go build ./pkg/mod/sigs.k8s.io/controller-tools@v0.4.1/cmd/controller-gen
cd ./pkg/mod/sigs.k8s.io/kustomize/kustomize/v3@v3.8.7
sudo go build -buildvcs=false
sudo chown <user>:<user> kustomize
cp kustomize ../../../../../..
cd ~/dataStore/opensearch/opensearch-k8s-operator-main/opensearch-operator
rm -rf ./bin/pkg
go env -u GOPATH
go env -u GOBIN

make build manifests

kubectl config get-clusters

docker build . --tag=localhost:5000/opster/opensearch-k8s-operator:1.0.2
docker push localhost:5000/opster/opensearch-k8s-operator:1.0.2

make install

make deploy

cd ~/dataStore

kubectl apply -f ../../../opensearch/securityconfig-secret.yaml
kubectl apply -f ../../../opensearch/opensearch-cluster.yaml

kubectl -n opensearch-operator-system port-forward svc/opensearch 9200 &

kubectl -n opensearch-operator-system port-forward svc/opensearch-dashboards 5601 &

containers:
    - name: dashboards
      image: docker.io/opensearchproject/opensearch-dashboards:1.3.1
      ports:
        - name: http
          containerPort: 5601
          protocol: TCP
      env:
        - name: OPENSEARCH_HOSTS
          value: http://opensearch.opensearch-operator-system.svc.cluster.local:9200

# remove the CRD finalizer blocking on custom resource cleanup
kubectl patch crd/opensearchclusters.opensearch.opster.io -p '{"metadata":{"finalizers":[]}}' --type=merge

kubectl -n opensearch-operator-system exec -it opensearch-masters-0 -c opensearch -- /bin/sh -c "kill 1"



./securityadmin.sh -diagnose -cd ../securityconfig/ -icl -nhnv \
   -cacert ../../../config/tls-http/ca.crt \
   -cert ../../../config/tls-http/tls.crt \
   -key ../../../config/tls-http/tls.key


helm repo add opensearch-operator https://opster.github.io/opensearch-k8s-operator-chart/
helm install opensearch-operator opensearch-operator/opensearch-operator

kubectl apply -f ./opensearch/securityconfig-secret.yaml
kubectl apply -f ./opensearch/opensearch-cluster.yaml

  - verbs:
      - create
      - list
      - watch
    apiGroups:
      - batch
    resources:
      - jobs

https://stackoverflow.com/a/61499028
update write threadpool size
curl -XPUT  _cluster/settings -d '{
    "persistent" : {
        "thread_pool.write.queue_size" : <new_size>
    }
}'

curl -XPOST localhost:30080/opensearch/_plugins/_performanceanalyzer/cluster/config -H 'Content-Type: application/json' -d '{"enabled": true}' -u 'admin:admin' -k
curl -XPOST localhost:30080/opensearch/_plugins/_performanceanalyzer/rca/cluster/config -H 'Content-Type: application/json' -d '{"enabled": true}' -u 'admin:admin' -k

kubectl -n opensearch-operator-system port-forward svc/opensearch 9600 &
./downloads/opensearch-perf-top-linux --dashboard ClusterOverview --endpoint localhost:9600
./downloads/opensearch-perf-top-linux --dashboard ClusterNetworkMemoryAnalysis --endpoint localhost:9600
./downloads/opensearch-perf-top-linux --dashboard ClusterThreadAnalysis --endpoint localhost:9600
./downloads/opensearch-perf-top-linux --dashboard NodeAnalysis --endpoint localhost:9600 --node l0Nb9t4L

curl --url "localhost:9600/_plugins/_performanceanalyzer/rca" -u 'admin:admin' -k -XGET

opensearch 2.0 upgrade:
https://github.com/opensearch-project/OpenSearch-Dashboards/issues/1642#issuecomment-1141709055

curl http://localhost:5601/api/status -u "admin:admin" -v
curl -H 'Authorization:  Basic YWRtaW46YWRtaW4=' http://localhost:5601/api/status -v

./plugins/opensearch-security/tools/securityadmin.sh -diagnose -cd ../securityconfig/ -icl -nhnv \
   -cacert ./config/tls-http/ca.crt \
   -cert ./config/tls-http/tls.crt \
   -key ./config/tls-http/tls.key

kubectl delete -f ./opensearch/opensearch-securityconfig-update.yaml

curl --cacert /certs/ca.crt --cert /certs/tls.crt --key /certs/tls.key https://opensearch.opensearch-operator-system.svc.cluster.local:9200

curl --cacert /certs/ca.crt --cert /certs/tls.crt --key /certs/tls.key --connect-to opensearch-masters-0:9200:10.96.197.83:9200 https://opensearch-masters-0:9200

./plugins/opensearch-security/tools/securityadmin.sh -diagnose -cd ../securityconfig/ -icl -nhnv \
   -cacert /certs/ca.crt \
   -cert /certs/tls.crt \
   -key /certs/tls.key \
   -h opensearch-masters-0.opensearch-operator-system.pod.cluster.local

/usr/share/opensearch/plugins/opensearch-security/tools/securityadmin.sh \
   -cd /usr/share/opensearch/plugins/opensearch-security/securityconfig/ \
   -icl -nhnv -cacert /usr/share/opensearch/config/tls-transport/ca.crt  \
   -cert /usr/share/opensearch/config/tls-transport/opensearch-masters-0.crt  \
   -key /usr/share/opensearch/config/tls-transport/opensearch-masters-0.key \
   -h localhost