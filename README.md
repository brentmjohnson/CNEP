# Cloud Native Experimentation Platform (CNEP)
Automated deployment of a complete cloud native platform to support experimentation with cloud native technologies.

## To provision:
ansible-playbook ./ansible/hyperv-k8s-provisioner/main.yml \
ansible-playbook ./main.yaml -i ./ansible/hyperv-k8s-provisioner/k8s-setup/clusters/k8s/k8s-inventory-k8s