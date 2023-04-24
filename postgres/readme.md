wget https://github.com/zalando/postgres-operator/archive/refs/tags/v1.9.0.tar.gz && tar -xvf v1.9.0.tar.gz && rm v1.9.0.tar.gz

cd postgres-operator-1.9.0/ui/

make

docker push k8s-lb:5000/zalan.do/acid/postgres-operator-ui:v1.9.0.1