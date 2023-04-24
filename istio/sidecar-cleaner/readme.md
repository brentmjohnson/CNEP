wget https://gitlab.com/kubitus-project/kubitus-pod-cleaner-operator/-/archive/v1.1.0/kubitus-pod-cleaner-operator-v1.1.0.tar.gz && tar -xvf kubitus-pod-cleaner-operator-v1.1.0.tar.gz && rm kubitus-pod-cleaner-operator-v1.1.0.tar.gz

https://kopf.readthedocs.io/en/latest/walkthrough/prerequisites/

pip install kopf

cd istio/sidecar-cleaner

kubectl apply -f ./sidecar-cleaner-manifests.yaml

cd kubitus-pod-cleaner-operator-v1.1.0/

pip install -r requirements.txt

kopf run ./kubitus_pod_cleaner_operator/handlers.py --verbose

docker build . --tag=k8s-lb:5000/kubitus-project/kubitus-pod-cleaner-operator:v1.1.0.1

docker push k8s-lb:5000/kubitus-project/kubitus-pod-cleaner-operator:v1.1.0.1