10 Gib = 10.73741824 GB

powershell(admin):

New-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker-1.vhdx -SizeBytes 10GB
New-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker-2.vhdx -SizeBytes 10GB
New-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker2-1.vhdx -SizeBytes 10GB
New-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker2-2.vhdx -SizeBytes 10GB
New-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker3-1.vhdx -SizeBytes 10GB
New-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker3-2.vhdx -SizeBytes 10GB

Mount-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker-1.vhdx
Mount-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker-2.vhdx
Mount-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker2-1.vhdx
Mount-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker2-2.vhdx
Mount-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker3-1.vhdx
Mount-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker3-2.vhdx

GET-CimInstance -query "SELECT * from Win32_DiskDrive"

wsl --mount \\.\PHYSICALDRIVE1 --bare
wsl --mount \\.\PHYSICALDRIVE2 --bare
wsl --mount \\.\PHYSICALDRIVE3 --bare
wsl --mount \\.\PHYSICALDRIVE4 --bare
wsl --mount \\.\PHYSICALDRIVE5 --bare
wsl --mount \\.\PHYSICALDRIVE6 --bare

kubectl drain k8s-0-worker3 --ignore-daemonsets
docker stop k8s-0-worker3
kubectl drain k8s-0-worker2 --ignore-daemonsets
docker stop k8s-0-worker2
kubectl drain k8s-0-worker --ignore-daemonsets
docker stop k8s-0-worker
kubectl drain k8s-0-control-plane --ignore-daemonsets
docker stop k8s-0-control-plane
docker stop kind-registry

docker start kind-registry
docker start k8s-0-control-plane
kubectl uncordon k8s-0-control-plane
docker start k8s-0-worker
kubectl uncordon k8s-0-worker
docker start k8s-0-worker2
kubectl uncordon k8s-0-worker2
docker start k8s-0-worker3
kubectl uncordon k8s-0-worker3

sudo sgdisk --zap-all /dev/sdb
sudo dd if=/dev/zero of=/dev/sdb bs=4M count=1
sudo blkdiscard -f /dev/sdb
sudo partprobe /dev/sdb

sudo sgdisk --zap-all /dev/sdc
sudo dd if=/dev/zero of=/dev/sdc bs=4M count=1
sudo blkdiscard -f /dev/sdc
sudo partprobe /dev/sdc

sudo sgdisk --zap-all /dev/sdd
sudo dd if=/dev/zero of=/dev/sdd bs=1M count=100 oflag=direct,dsync
sudo blkdiscard -f /dev/sdd
sudo partprobe /dev/sdd
sudo sgdisk --zap-all /dev/sde
sudo dd if=/dev/zero of=/dev/sde bs=1M count=100 oflag=direct,dsync
sudo blkdiscard -f /dev/sde
sudo partprobe /dev/sde
sudo sgdisk --zap-all /dev/sdf
sudo dd if=/dev/zero of=/dev/sdf bs=1M count=100 oflag=direct,dsync
sudo blkdiscard -f /dev/sdf
sudo partprobe /dev/sdf
sudo sgdisk --zap-all /dev/sdg
sudo dd if=/dev/zero of=/dev/sdg bs=1M count=100 oflag=direct,dsync
sudo blkdiscard -f /dev/sdg
sudo partprobe /dev/sdg
sudo sgdisk --zap-all /dev/sdh
sudo dd if=/dev/zero of=/dev/sdh bs=1M count=100 oflag=direct,dsync
sudo blkdiscard -f /dev/sdh
sudo partprobe /dev/sdh
sudo sgdisk --zap-all /dev/sdi
sudo dd if=/dev/zero of=/dev/sdi bs=1M count=100 oflag=direct,dsync
sudo blkdiscard -f /dev/sdi
sudo partprobe /dev/sdi

Dismount-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker-1.vhdx
Dismount-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker-2.vhdx
Dismount-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker2-1.vhdx
Dismount-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker2-2.vhdx
Dismount-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker3-1.vhdx
Dismount-VHD -Path C:\WSLImages\Ubuntu-22.04\k8s-0-worker3-2.vhdx

docker stop k8s-0-worker3
docker stop k8s-0-worker2
docker stop k8s-0-worker
docker stop k8s-0-control-plane
docker stop kind-registry

docker start kind-registry
docker start k8s-0-control-plane
docker start k8s-0-worker
docker start k8s-0-worker2
docker start k8s-0-worker3
