1. https://fabianlee.org/2021/05/31/ansible-installing-the-latest-ansible-on-ubuntu/
2. # make sure Python3 is installed
sudo apt update
sudo apt install software-properties-common python3 python3-pip -y

python3 --version

# ensure requests module is installed
sudo pip3 install requests
3. sudo -E apt-add-repository --yes --update ppa:ansible/ansible
4. sudo apt-get update
sudo apt-get install ansible-core -y
5. $ ansible --version

# ping module, ignore warnings
`$ ansible -m ping localhost

localhost | SUCCESS => {
"changed": false,
"ping": "pong"
}

# libvirt-k8s-provisioner
1. cd ~/dataStore/ansible && wget https://codeload.github.com/kubealex/libvirt-k8s-provisioner/zip/refs/heads/master && unzip master && rm master
cd ~/dataStore/ansible && wget https://github.com/fabianlee/kubeadm-cluster-kvm/archive/refs/heads/main.zip && unzip main.zip && rm main.zip
2. cd ~/dataStore/ansible/libvirt-k8s-provisioner-master
3. ansible-galaxy collection install -r requirements.yml
4. sudo vi /etc/ansible/hosts
[vm_host]
127.0.0.1
5. ansible-playbook main.yml

ansible-playbook main.yml -i k8s-setup/clusters/k8s/k8s-inventory-k8s