wget https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux-msft-wsl-5.15.90.1.tar.gz
tar -xvf linux-msft-wsl-5.15.90.1.tar.gz
rm linux-msft-wsl-5.15.90.1.tar.gz
mv WSL2-Linux-Kernel-linux-msft-wsl-5.15.90.1 WSL2-Linux-Kernel 

sudo apt-get update

export _pkgbase=dxgkrnl
export pkgver=5.15.90.1
export pkgdir=""

sudo mkdir -p "${pkgdir}"/usr/src/${_pkgbase}-${pkgver}/
sudo cp -r WSL2-Linux-Kernel/drivers/hv/dxgkrnl/* "${pkgdir}"/usr/src/${_pkgbase}-${pkgver}/
sudo cp WSL2-Linux-Kernel/include/uapi/misc/d3dkmthk.h "${pkgdir}"/usr/src/${_pkgbase}-${pkgver}/
# head -29 /usr/src/dxgkrnl-5.15.90.1/dxgkrnl.h | tail -1
sudo sed -e "s/<uapi\/misc\/d3dkmthk.h>/\"d3dkmthk.h\"/" \
      -i "${pkgdir}"/usr/src/${_pkgbase}-${pkgver}/dxgkrnl.h
# head -29 /usr/src/dxgkrnl-5.15.90.1/dxgkrnl.h | tail -1
# diff -u /usr/src/dxgkrnl-5.15.90.1/dxgvmbus.c updated-dxgvmbus.c > fix_recv.patch
# sudo patch --ignore-whitespace -d "${pkgdir}"/usr/src/${_pkgbase}-${pkgver} < fix_recv.patch
# sudo patch -R --ignore-whitespace -d "${pkgdir}"/usr/src/${_pkgbase}-${pkgver} < fix_recv.patch

sudo install -Dm644 dkms.conf "${pkgdir}"/usr/src/${_pkgbase}-${pkgver}/dkms.conf
sudo sed -e "s/@_PKGBASE@/${_pkgbase}/" \
      -e "s/@PKGVER@/${pkgver}/" \
      -i "${pkgdir}"/usr/src/${_pkgbase}-${pkgver}/dkms.conf

sudo install -Dm644 extra-defines.h "${pkgdir}"/usr/src/${_pkgbase}-${pkgver}/extra-defines.h

sudo apt-get install -y dkms

cd /usr/src
sudo dkms build ./${_pkgbase}-${pkgver}
# sudo rm -r /var/lib/dkms/dxgkrnl/

krnl_ver=`uname -r`

# scp ./hyper-v/gpu-p/oneclick-gpu-pv/dxgkrnl-dkms/dxgkrnl.ko GPUPV3:~
# sudo mv dxgkrnl.ko /lib/modules/$krnl_ver/kernel/drivers/hv/
sudo mv /var/lib/dkms/dxgkrnl/5.15.90.1/$krnl_ver/x86_64/module/dxgkrnl.ko /lib/modules/$krnl_ver/kernel/drivers/hv/
# scp GPUPV2:/lib/modules/5.15.0-60-generic/kernel/drivers/hv/dxgkrnl.ko ./hyper-v/gpu-p/oneclick-gpu-pv/dxgkrnl-dkms
cd /lib/modules/$krnl_ver/kernel/drivers/hv/
sudo depmod
sudo modprobe dxgkrnl
# sudo modprobe -r dxgkrnl

# sudo add-apt-repository ppa:kisak/kisak-mesa
sudo apt install -y mesa-utils

echo "export MESA_LOADER_DRIVER_OVERRIDE=d3d12" | sudo tee -a /etc/profile.d/d3d.sh

echo "DONE"
