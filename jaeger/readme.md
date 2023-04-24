https://www.jaegertracing.io/docs/1.35/operator/

kubectl create namespace observability
kubectl create -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.35.0/jaeger-operator.yaml

kubectl create secret generic -n observability jaeger-secrets --from-literal=ES_PASSWORD=admin --from-literal=ES_USERNAME=admin

kubectl apply -f ./jaeger/jaeger.yaml

kubectl -n observability port-forward svc/jaeger-query 16686 &

kubectl run -it --tty -n observability --rm debug --image=alpine --labels="app=debug,version=latest" --restart=Never -- sh
apk add curl

kubectl -n observability port-forward svc/jaeger-query 16686 &

http://localhost:16686/

curl http://jaeger-query:16687/metrics

https://github.com/jaegertracing/spark-dependencies/issues/110#issuecomment-1015433450

cd ./jaeger
wget https://codeload.github.com/jaegertracing/spark-dependencies/zip/refs/heads/main && unzip main && rm -rf main
cd ./spark-dependencies-main
./mvnw clean install -DskipTests

docker build . --tag=localhost:5000/jaegertracing/spark-dependencies:latest
docker push localhost:5000/jaegertracing/spark-dependencies:latest

kubectl patch CronJob/jaeger-spark-dependencies -n observability --type json -p='[
  {"op": "add", "path": "/spec/jobTemplate/spec/template/spec/containers/0/env/-", "value": { "name": "ES_USE_ALIASES", "value": "true" }}
]'

kubectl apply -f ./jaeger/ingress/jaeger-route.yaml