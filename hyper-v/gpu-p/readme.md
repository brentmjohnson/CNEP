
https://github.com/brokeDude2901/dxgkrnl_ubuntu

ubuntu: 5.15.0-60-generic
wsl: linux-msft-wsl-5.15.90.1

cat /var/log/installer/autoinstall-user-data

cloud-localds GPUPV2/seed.iso GPUPV2/user-data GPUPV2/meta-data
cp GPUPV2/seed.iso /mnt/c/Users/<user>/Downloads/GPUPV2-seed.iso

sudo lshw -C display
sudo glxinfo -B

# simple-test
1. cd terraform/simple-test
2. terraform init
3. terraform apply
4. terraform destroy

# mainline tool
sudo add-apt-repository ppa:cappelikan/ppa -y

sudo apt-get update && sudo apt-get upgrade && sudo apt-get install mainline

sudo apt-get install linux-image-5.15.0-60-generic linux-headers-5.15.0-60-generic linux-modules-extra-5.15.0-60-generic
reboot
sudo apt-get purge linux-image-5.19.0-32-generic

sudo nano /boot/grub/grub.cfg for grub timeout
insmod dxgkrnl

https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel
https://askubuntu.com/questions/1435591/correct-way-to-build-kernel-with-hardware-support-fix-patches-ubuntu-22-04-lts
# kernel
sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
sudo apt-get update

sudo apt-get build-dep linux linux-image-unsigned-$(uname -r)

sudo apt-get install libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm

apt-get source linux-image-unsigned-$(uname -r)

cd linux-5.15.0/

chmod a+x debian/rules
chmod a+x debian/scripts/*
chmod a+x debian/scripts/misc/*
chmod a+x -R ./scripts

make clean && make mrproper

cp /boot/config-$(uname -r) ./.config
vi .config

make -j16 deb-pkg LOCALVERSION=-gpu

# wsl kernel stuff
wget https://github.com/brokeDude2901/dxgkrnl_ubuntu/archive/refs/tags/main.tar.gz && \
tar -xvf main.tar.gz && \
rm main.tar.gz

wget https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux-msft-wsl-5.15.90.1.tar.gz && \
tar -xvf linux-msft-wsl-5.15.90.1.tar.gz && \
rm linux-msft-wsl-5.15.90.1.tar.gz

wget https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux-msft-wsl-5.10.102.1.tar.gz && \
tar -xvf linux-msft-wsl-5.10.102.1.tar.gz && \
rm linux-msft-wsl-5.10.102.1.tar.gz

scp GPUPV2:/home/<user>/linux-5.15.0/.config \\wsl.localhost\Ubuntu-22.04\home\<user>\dataStore\hyper-v\gpu-p

# .config updates
CONFIG_HYPERV=y
CONFIG_DXGKRNL=y

https://docs.amd.com/bundle/ROCm-Installation-Guide-v5.4.3/page/How_to_Install_ROCm.html#d23e6278
# rocm
1. sudo apt-get update
wget https://repo.radeon.com/amdgpu-install/5.4.3/ubuntu/jammy/amdgpu-install_5.4.50403-1_all.deb 
sudo apt-get install ./amdgpu-install_5.4.50403-1_all.deb
2. sudo amdgpu-install --usecase=rocm
3. export LD_LIBRARY_PATH=/opt/rocm-5.4.3/lib:/opt/rocm-5.4.3/lib64