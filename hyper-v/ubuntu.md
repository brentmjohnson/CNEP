https://computingforgeeks.com/install-kubernetes-cluster-ubuntu-jammy/
1. sudo apt update
sudo apt -y full-upgrade

sudo fwupdmgr update -y
[ -f /var/run/reboot-required ] && sudo reboot -f
2. sudo apt install curl apt-transport-https -y
curl -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/k8s.gpg
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
3. sudo apt install ipvsadm -y
4. sudo apt install lsof -y
4. sudo apt update
sudo apt install wget curl vim git kubelet=1.24.4-00 kubeadm=1.24.4-00 kubectl=1.24.4-00 -y [--allow-downgrades --allow-change-held-packages]
sudo apt-mark hold kubelet kubeadm kubectl
5. # Enable kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Increase file descriptor soft limits
sudo tee -a /etc/security/limits.conf<<EOF

*         soft    nofile      1048576
root      soft    nofile      1048576
EOF

sudo sed -i 's/65536/1048576/' /etc/security/limits.conf

# Increase inotify max user instances
echo fs.inotify.max_user_instances=1024 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

cat /proc/sys/fs/inotify/max_user_instances
cat /etc/sysctl.conf | grep max_user_instances

# Increase aio-max-nr count
echo fs.aio-max-nr=262144 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

cat /proc/sys/fs/aio-max-nr
cat /etc/sysctl.conf | grep aio-max-nr

# Increase max_map_count count
echo vm.max_map_count=262144 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

cat /proc/sys/vm/max_map_count
cat /etc/sysctl.conf | grep max_map_count

# Add some settings to sysctl
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
sudo sysctl --system
5. # Configure persistent loading of modules
sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

# Load at runtime
sudo modprobe overlay
sudo modprobe br_netfilter

# Ensure sysctl params are set
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload configs
sudo sysctl --system

# Disable transparent huge pages
sudo tee /etc/systemd/system/disable-transparent-huge-pages.service<<EOF
[Unit]
Description=Disable Transparent Huge Pages (THP)
DefaultDependencies=no
After=sysinit.target local-fs.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo never | tee /sys/kernel/mm/transparent_hugepage/enabled > /dev/null'

[Install]
WantedBy=basic.target
EOF
sudo systemctl daemon-reload
sudo systemctl start disable-transparent-huge-pages
sudo systemctl enable disable-transparent-huge-pages
cat /sys/kernel/mm/transparent_hugepage/enabled

# Install required packages
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

# Add Docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install containerd
sudo apt update
sudo apt install -y containerd.io
sudo crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock

# Configure containerd and start service
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd
systemctl status containerd
6. cat /etc/containerd/config.toml | grep "SystemdCgroup = false"
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
cat /etc/containerd/config.toml | grep "SystemdCgroup = true"

cat /etc/containerd/config.toml | grep -A 1 '\[plugins."io.containerd.grpc.v1.cri".registry.mirrors\]'
sudo sed -i 's/\[plugins\.\"io\.containerd\.grpc\.v1\.cri\"\.registry\.mirrors\]/\[plugins\.\"io\.containerd\.grpc\.v1\.cri\"\.registry\.mirrors\]\n        \[plugins\.\"io\.containerd\.grpc\.v1\.cri\"\.registry\.mirrors\.\"10\.0\.0\.2:5000\"\]\n          endpoint = \[\"http:\/\/10\.0\.0\.2:5000\"\]/' /etc/containerd/config.toml
cat /etc/containerd/config.toml | grep -A 2 '\[plugins."io.containerd.grpc.v1.cri".registry.mirrors\]'
7. sudo systemctl restart containerd
systemctl status containerd
8. lsmod | grep br_netfilter
9. sudo systemctl enable kubelet
10. scp -rp ./cluster/featureGates/tracing/ 10.0.0.3:/tmp
scp ./hyper-v/kubeadm-config-control.yaml 10.0.0.3:/tmp
11. sudo cp -r /tmp/tracing /etc/kubernetes/ && sudo chown -R root:root /etc/kubernetes/tracing
sudo kubeadm  init --config /tmp/kubeadm-config-control.yaml --upload-certs --ignore-preflight-errors=NumCPU,Mem,Swap --dry-run

sudo kubeadm reset
sudo rm -rf /etc/cni/net.d
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
sudo ipvsadm --clear

sudo rm -rf /var/lib/rook
sudo sgdisk --zap-all /dev/sdb
sudo dd if=/dev/zero of=/dev/sdb bs=4M count=1
sudo blkdiscard -f /dev/sdb
sudo partprobe /dev/sdb
sudo sgdisk --zap-all /dev/sdc
sudo dd if=/dev/zero of=/dev/sdc bs=4M count=1
sudo blkdiscard -f /dev/sdc
sudo partprobe /dev/sdc

12. yes | sudo cp -i /etc/kubernetes/admin.conf /tmp/ && sudo chown <user>:<user> /tmp/admin.conf
scp 10.0.0.3:/tmp/admin.conf ./hyper-v/.kube/config
cp ./hyper-v/.kube/config $HOME/.kube/config
13. scp ./hyper-v/kubeadm-config-control.yaml 10.0.0.5:/tmp
sudo kubeadm join 10.0.0.2:6443 --config /tmp/kubeadm-config-control.yaml --ignore-preflight-errors=NumCPU,Mem,Swap --dry-run
14. scp ./hyper-v/kubeadm-config-worker.yaml 10.0.0.8:/tmp
sudo kubeadm join 10.0.0.2:6443 --config /tmp/kubeadm-config-worker.yaml --ignore-preflight-errors=NumCPU,Mem,Swap --dry-run

---
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join 10.0.0.2:6443 --token xkdh5h.1wkcs5y98fo8jueu \
        --discovery-token-ca-cert-hash sha256:95a6e7af790c8a293fbb21b3f9f9881494bef12471ddc2b91f74355fe954fd96 \
        --control-plane --certificate-key e60d923350f5dea978f82865aaa5847d4519426e4b48de482423e8d440a5616e

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.0.0.2:6443 --token xkdh5h.1wkcs5y98fo8jueu \
        --discovery-token-ca-cert-hash sha256:95a6e7af790c8a293fbb21b3f9f9881494bef12471ddc2b91f74355fe954fd96