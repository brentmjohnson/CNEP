https://unix.stackexchange.com/questions/594470/wsl-2-does-not-have-lib-modules

sudo apt install build-essential flex bison libssl-dev libelf-dev git dwarves

uname -r
    5.10.102.1-microsoft-standard-WSL2

wget https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux-msft-wsl-5.15.90.1.tar.gz && tar -xvf linux-msft-wsl-5.15.90.1.tar.gz && rm linux-msft-wsl-5.15.90.1.tar.gz

cd WSL2-Linux-Kernel-linux-msft-wsl-5.15.90.1/

make clean && make mrproper

cp Microsoft/config-wsl .config

https://github.com/kubernetes-sigs/kind/issues/1740#issuecomment-702945425

cat .config | grep "CONFIG_NETFILTER_XT_MATCH_RECENT"
sed -i 's/# CONFIG_NETFILTER_XT_MATCH_RECENT is not set/CONFIG_NETFILTER_XT_MATCH_RECENT=y/' .config
cat .config | grep "CONFIG_NETFILTER_XT_MATCH_RECENT"

---for ebpf and perf tools---

https://gist.github.com/MarioHewardt/5759641727aae880b29c8f715ba4d30f

cat .config | grep "CONFIG_IKHEADERS"
sed -i 's/# CONFIG_IKHEADERS is not set/CONFIG_IKHEADERS=y/' .config
cat .config | grep "CONFIG_IKHEADERS"

cat .config | grep "CONFIG_NET_SCH_SFQ"
sed -i 's/# CONFIG_NET_SCH_SFQ is not set/CONFIG_NET_SCH_SFQ=y/' .config
cat .config | grep "CONFIG_NET_SCH_SFQ"

cat .config | grep "CONFIG_NET_ACT_POLICE"
sed -i 's/# CONFIG_NET_ACT_POLICE is not set/CONFIG_NET_ACT_POLICE=y/' .config
cat .config | grep "CONFIG_NET_ACT_POLICE"

cat .config | grep "CONFIG_NET_ACT_GACT"
sed -i 's/# CONFIG_NET_ACT_GACT is not set/CONFIG_NET_ACT_GACT=y/' .config
cat .config | grep "CONFIG_NET_ACT_GACT"

---for iptables conntrack---

https://github.com/istio/istio/issues/37885#issuecomment-1067909539

cat .config | grep "CONFIG_NF_CONNTRACK_ZONES"
sed -i 's/# CONFIG_NF_CONNTRACK_ZONES is not set/CONFIG_NF_CONNTRACK_ZONES=y/' .config
cat .config | grep "CONFIG_NF_CONNTRACK_ZONES"

cat .config | grep "CONFIG_NETFILTER_XT_TARGET_CT"
sed -i 's/# CONFIG_NETFILTER_XT_TARGET_CT is not set/CONFIG_NETFILTER_XT_TARGET_CT=y/' .config
cat .config | grep "CONFIG_NETFILTER_XT_TARGET_CT"

---for rook / ceph / rbd---

https://github.com/docker/for-mac/issues/1781
https://github.com/linuxkit/linuxkit/pull/2963/files#diff-a4996a832c36fb3cc4455d963ac856135d80b1bd0f4723622cc21b0909a21318

cat .config | grep "CONFIG_BLK_DEV_DRBD"
sed -i 's/# CONFIG_BLK_DEV_DRBD is not set/CONFIG_BLK_DEV_DRBD=y/' .config
cat .config | grep "CONFIG_BLK_DEV_DRBD"

cat .config | grep "CONFIG_BLK_DEV_RBD"
sed -i 's/# CONFIG_BLK_DEV_RBD is not set/CONFIG_BLK_DEV_RBD=y/' .config
cat .config | grep "CONFIG_BLK_DEV_RBD"

---do i need this??? CONFIG_LRU_CACHE---

---for kvm / qemu---
https://boxofcables.dev/kvm-optimized-custom-kernel-wsl2-2022/

cat .config | grep "CONFIG_KVM_GUEST"
sed -i 's/# CONFIG_KVM_GUEST is not set/CONFIG_KVM_GUEST=y/g' .config
cat .config | grep "CONFIG_KVM_GUEST"

cat .config | grep "CONFIG_ARCH_CPUIDLE_HALTPOLL"
sed -i 's/# CONFIG_ARCH_CPUIDLE_HALTPOLL is not set/CONFIG_ARCH_CPUIDLE_HALTPOLL=y/g' .config
cat .config | grep "CONFIG_ARCH_CPUIDLE_HALTPOLL"

cat .config | grep "CONFIG_HYPERV_IOMMU"
sed -i 's/# CONFIG_HYPERV_IOMMU is not set/CONFIG_HYPERV_IOMMU=y/g' .config
cat .config | grep "CONFIG_HYPERV_IOMMU"

cat .config | grep "CONFIG_PARAVIRT_TIME_ACCOUNTING"
cat .config | grep "CONFIG_PARAVIRT_CLOCK"
sed -i '/^# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set/a CONFIG_PARAVIRT_CLOCK=y' .config
cat .config | grep "CONFIG_PARAVIRT_TIME_ACCOUNTING"
cat .config | grep "CONFIG_PARAVIRT_CLOCK"

cat .config | grep "CONFIG_CPU_IDLE_GOV_TEO"
cat .config | grep "CONFIG_CPU_IDLE_GOV_HALTPOLL"
sed -i '/^# CONFIG_CPU_IDLE_GOV_TEO is not set/a CONFIG_CPU_IDLE_GOV_HALTPOLL=y' .config
cat .config | grep "CONFIG_CPU_IDLE_GOV_TEO"
cat .config | grep "CONFIG_CPU_IDLE_GOV_HALTPOLL"

cat .config | grep "CONFIG_CPU_IDLE_GOV_HALTPOLL"
cat .config | grep "CONFIG_HALTPOLL_CPUIDLE"
sed -i '/^CONFIG_CPU_IDLE_GOV_HALTPOLL=y/a CONFIG_HALTPOLL_CPUIDLE=y' .config
cat .config | grep "CONFIG_CPU_IDLE_GOV_HALTPOLL"
cat .config | grep "CONFIG_HALTPOLL_CPUIDLE"

cat .config | grep "CONFIG_HAVE_ARCH_KCSAN"
sed -i 's/CONFIG_HAVE_ARCH_KCSAN=y/CONFIG_HAVE_ARCH_KCSAN=n/g' .config
cat .config | grep "CONFIG_HAVE_ARCH_KCSAN"

cat .config | grep "CONFIG_HAVE_ARCH_KCSAN"
cat .config | grep "CONFIG_KCSAN"
sed -i '/^CONFIG_HAVE_ARCH_KCSAN=n/a CONFIG_KCSAN=n' .config
cat .config | grep "CONFIG_HAVE_ARCH_KCSAN"
cat .config | grep "CONFIG_KCSAN"

---

export KERNELRELEASE=5.15.90.1-microsoft-standard-WSL2

make KERNELRELEASE=$KERNELRELEASE -j $(expr $(nproc) - 1)

---

defaults for all prompts

make KERNELRELEASE=$KERNELRELEASE modules -j $(expr $(nproc) - 1)

sudo make KERNELRELEASE=$KERNELRELEASE modules_install

From Windows, copy \\wsl.localhost\Ubuntu-22.04\home\<user>\WSL2-Linux-Kernel-linux-msft-wsl-5.15.90.1\arch\x86\boot\bzImage
to 
C:\WSLImages\Kernels\linux-msft-wsl-5.15.90.1

or 

cp /home/<user>/WSL2-Linux-Kernel-linux-msft-wsl-5.15.90.1/arch/x86/boot/bzImage /mnt/c/WSLImages/Kernels/linux-msft-wsl-5.15.90.1/

ip_vs ip_vs_rr ip_vs_wrr ip_vs_sh

