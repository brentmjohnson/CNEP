<!-- modprobe ipv6
echo "ipv6" >> /etc/modules
vi /etc/network/interfaces
---
iface eth0 inet6 static
      address fd11:10:0:0::3
      netmask 64
      gateway fd11:10:0:0::1
      pre-up echo 0 > /proc/sys/net/ipv6/conf/eth0/accept_ra
---
vi /etc/hosts
---
127.0.0.1       localhost
::1             localhost ipv6-localhost ipv6-loopback
fe00::0         ipv6-localnet
ff00::0         ipv6-mcastprefix
ff02::1         ipv6-allnodes
ff02::2         ipv6-allrouters
ff02::3         ipv6-allhosts

10.0.0.3        k8s-0-control-0
fd11:10:0:0::3  k8s-0-control-0 -->
---
sed -i 's/#http:\/\/dl-cdn\.alpinelinux\.org\/alpine\/v3\.16\/community/http:\/\/dl-cdn\.alpinelinux\.org\/alpine\/v3\.16\/community/g' /etc/apk/repositories
sed -i 's/#http:\/\/dl-cdn\.alpinelinux\.org\/alpine\/edge\/community/http:\/\/dl-cdn\.alpinelinux\.org\/alpine\/edge\/community/g' /etc/apk/repositories
sed -i 's/#http:\/\/dl-cdn\.alpinelinux\.org\/alpine\/edge\/testing/http:\/\/dl-cdn\.alpinelinux\.org\/alpine\/edge\/testing/g' /etc/apk/repositories
apk update && apk upgrade
apk add kubeadm
apk add containerd
rc-update add containerd default
apk add kubelet
rc-update add kubelet default
echo 'br_netfilter
ip_vs_rr
ip_vs_wrr
ip_vs_sh' > /etc/modules-load.d/k8s.conf
modprobe br_netfilter ip_vs_rr ip_vs_wrr ip_vs_sh
vi /etc/sysctl.conf
    net.ipv4.ip_forward = 1
<!-- echo 1 > /proc/sys/net/ipv4/ip_forward -->
apk add ipvsadm
apk add ip6tables
apk add curl
apk add lsblk
apk add parted
apk add cfdisk
apk add sgdisk

https://wiki.alpinelinux.org/wiki/Running_glibc_programs
apk add debootstrap
for i in /proc/sys/kernel/grsecurity/chroot_*; do echo 0 | tee $i; done
mkdir ~/chroot
debootstrap --arch=amd64 bookworm ~/chroot
for i in /proc/sys/kernel/grsecurity/chroot_*; do echo 1 | tee $i; done
chroot ~/chroot /bin/bash
apt-get install linux-utils

mkdir -p /lib64
ln -s /root/chroot/lib/x86_64-linux-gnu/ld-2.33.so /lib64
ln -s /root/chroot/lib/x86_64-linux-gnu/libudev.so.1 /lib64
printf '/root/chroot/lib/x86_64-linux-gnu/gnu\n/root/chroot/lib/x86_64-linux-gnu\n' > /etc/ld.so.conf
/root/chroot/sbin/ldconfig
rm -rf /root/chroot/sys/ && ln -s /sys/ /root/chroot/

scp -rp ./cluster/featureGates/tracing/ root@10.0.0.5:/etc/kubernetes/
scp ./hyper-v/kubeadm-config-control.yaml root@10.0.0.3:/tmp
kubeadm  init --config /tmp/kubeadm-config-control.yaml --upload-certs --ignore-preflight-errors=NumCPU,Mem,Swap
kubeadm reset
rm -rf /etc/cni/net.d
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
ipvsadm --clear

scp root@10.0.0.3:/etc/kubernetes/admin.conf ./hyper-v/.kube/config
cp ./hyper-v/.kube/config $HOME/.kube/config

scp ./hyper-v/kubeadm-config-control.yaml root@10.0.0.5:/tmp
kubeadm join 10.0.0.2:6443 --config /tmp/kubeadm-config-control.yaml --ignore-preflight-errors=NumCPU,Mem,Swap

scp ./hyper-v/kubeadm-config-worker.yaml root@10.0.0.8:/tmp
kubeadm join 10.0.0.2:6443 --config /tmp/kubeadm-config-worker.yaml --ignore-preflight-errors=NumCPU,Mem,Swap
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

  kubeadm join 10.0.0.2:6443 --token 1wbqmv.9ll2na4rmfujupsx \
        --discovery-token-ca-cert-hash sha256:8ebdb164cffe4047493a75552b64a85d179befb6d5814427534ba9906fcbe9b7 \
        --control-plane --certificate-key 013070c4f422e3a256a07b3c408d2f9d366e18c2bbb6e18d5ecb4c13614bb69a

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.0.0.2:6443 --token 1wbqmv.9ll2na4rmfujupsx \
        --discovery-token-ca-cert-hash sha256:8ebdb164cffe4047493a75552b64a85d179befb6d5814427534ba9906fcbe9b7