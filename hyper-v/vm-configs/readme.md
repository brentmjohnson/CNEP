1. ssh 10.0.0.2 "cat /home/<user>/setup-alpine-seed" > ./k8s-lb/setup-alpine-seed
ssh 10.0.0.3 "sudo -S cat /var/log/installer/autoinstall-user-data" > ./k8s-control-0/user-data
ssh 10.0.0.4 "sudo -S cat /var/log/installer/autoinstall-user-data" > ./k8s-control-1/user-data
ssh 10.0.0.5 "sudo -S cat /var/log/installer/autoinstall-user-data" > ./k8s-control-2/user-data

1. cd ~/downloads
2. mkdir ubuntu-22.04.2-live-server-amd64 && bsdtar -C ubuntu-22.04.2-live-server-amd64 -xf /mnt/c/Users/<user>/Downloads/ubuntu-22.04.2-live-server-amd64.iso
3. cat ubuntu-22.04.2-live-server-amd64/boot/grub/grub.cfg
sudo sed -i 's/linux\t\/casper\/vmlinuz  ---/linux\t\/casper\/vmlinuz autoinstall quiet  ---/g' ubuntu-22.04.2-live-server-amd64/boot/grub/grub.cfg
sudo sed -i 's/timeout=30/timeout=1/g' ubuntu-22.04.2-live-server-amd64/boot/grub/grub.cfg
cat ubuntu-22.04.2-live-server-amd64/boot/grub/grub.cfg
4. xorriso -indev /mnt/c/Users/<user>/Downloads/ubuntu-22.04.2-live-server-amd64.iso -report_el_torito as_mkisofs
5. xorriso -as mkisofs \
--modification-date='2023021721571500' \
--grub2-mbr --interval:local_fs:0s-15s:zero_mbrpt,zero_gpt:'/mnt/c/Users/<user>/Downloads/ubuntu-22.04.2-live-server-amd64.iso' \
--protective-msdos-label \
-partition_cyl_align off \
-partition_offset 16 \
--mbr-force-bootable \
-append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b --interval:local_fs:3848588d-3858655d::'/mnt/c/Users/<user>/Downloads/ubuntu-22.04.2-live-server-amd64.iso' \
-appended_part_as_gpt \
-iso_mbr_part_type a2a0d0ebe5b9334487c068b6b72699c7 \
-c '/boot.catalog' \
-b '/boot/grub/i386-pc/eltorito.img' \
-no-emul-boot \
-boot-load-size 4 \
-boot-info-table \
--grub2-boot-info \
-eltorito-alt-boot \
-e '--interval:appended_partition_2_start_962147s_size_10068d:all::' \
-no-emul-boot \
-boot-load-size 10068 \
-o /mnt/c/Users/<user>/Downloads/ubuntu-22.04.2-live-server-amd64-autoinstall.iso ubuntu-22.04.2-live-server-amd64/

1. cd ~/dataStore/hyper-v/vm-configs
cloud-localds k8s-control-0/seed.iso k8s-control-0/user-data k8s-control-0/meta-data
cloud-localds k8s-control-1/seed.iso k8s-control-1/user-data k8s-control-1/meta-data
cloud-localds k8s-control-2/seed.iso k8s-control-2/user-data k8s-control-2/meta-data
cd ~/dataStore/hyper-v/vm-configs/alpine/localhost.apkovl && sudo tar -czf ../localhost.apkovl.tar.gz * && cd ../..
2. cp k8s-control-0/seed.iso /mnt/c/Users/<user>/Downloads/k8s-control-0-seed.iso
cp k8s-control-1/seed.iso /mnt/c/Users/<user>/Downloads/k8s-control-1-seed.iso
cp k8s-control-2/seed.iso /mnt/c/Users/<user>/Downloads/k8s-control-2-seed.iso
genisoimage -o ./k8s-lb/seed.iso -joliet -rock ./alpine/localhost.apkovl.tar.gz ./k8s-lb/setup-alpine-seed && cp ./k8s-lb/seed.iso /mnt/c/Users/<user>/Downloads/k8s-lb-seed.iso
cd ~/dataStore

1. mkdir /media/sr1 && mount /dev/sr1 /media/sr1
2. export ERASE_DISKS=/dev/sda
3. setup-alpine -e -f /media/sr1/user-data && poweroff

<!-- 1. scp ./k8s-lb/root-preseed.sh root@10.0.0.2:/root/root-preseed.sh
2. chmod +x ./root-preseed.sh && ./root-preseed.sh
3. scp ./k8s-lb/build-preseed.sh root@10.0.0.2:/home/build/build-preseed.sh
4. chown build:abuild /home/build/build-preseed.sh
5. su - build
6. mkdir tmp/ && export WORKDIR=./tmp
7. chmod +x ./build-preseed.sh && ./build-preseed.sh
8. scp root@10.0.0.2:/home/build/iso/alpine-preseed-virt-x86_64.iso /mnt/c/Users/<user>/Downloads/alpine-preseed-virt-x86_64-autoinstall.iso -->

1. mkdir alpine-preseed-virt-x86_64-autoinstall && bsdtar -C alpine-preseed-virt-x86_64-autoinstall -xf /mnt/c/Users/<user>/Downloads/alpine-preseed-virt-x86_64-autoinstall.iso
2. mkdir alpine-virt-3.16.2-x86_64 && bsdtar -C alpine-virt-3.16.2-x86_64 -xf /mnt/c/Users/<user>/Downloads/alpine-virt-3.16.2-x86_64.iso

<!-- 2. cp /media/sr1/user-data ./root-preseed.sh && chmod +x ./root-preseed.sh
3. ./root-preseed.sh
4. su - build
5. cp /media/sr1/meta-data ./build-preseed.sh && chmod +x ./build-preseed.sh
6. ./build-preseed.sh -->

1. cd ~/downloads
2. qemu-img create -f raw mykvm.config 32M
3. qemu-system-x86_64 -enable-kvm -m 384 \
-name mykvm \
-cdrom /mnt/c/Users/<user>/Downloads/alpine-extended-3.17.1-x86_64.iso \
-drive file=mykvm.config,if=virtio \
-net bridge,br=virbr0 -net nic,model=virtio \
-boot d &
4. login root
5. fdisk /dev/vda
n
p
1
default
default
w
6. mkdosfs /dev/vda1
7. mkdir -p /media/vda1
8. echo "/dev/vda1 /media/vda1 vfat rw 0 0" >> /etc/fstab
9. mount -a
10. sed -i 's/# LBU_MEDIA=usb/LBU_MEDIA=vda1/g' /etc/lbu/lbu.conf
rc-update add local boot
apk add python3
apk add dhcp
ln -s /etc/init.d/dhcpd /etc/init.d/dhcpd6
rc-update add dhcpd
rc-update add dhcpd6
setup-interfaces
/etc/init.d/networking restart
<!-- setup-apkcache -->
echo http://dl-cdn.alpinelinux.org/alpine/v3.17/main >> /etc/apk/repositories
apkupdate && apk add e2fsprogs
dd if=/dev/zero of=/root/apkcache.img bs=1M count=16
mkfs.ext2 -F /root/apkcache.img
mkdir -p /etc/apk/cache
mount -t ext2 /root/apkcache.img /etc/apk/cache/
apk update
apk add bind
rc-update add named
apk add radvd
rc-update add radvd
apk cache -v sync
lbu include /etc/init.d/dhcpd6
lbu include /root/apkcache.img
mkdir -p /var/cache/bind && chown named /var/cache/bind && lbu include /var/cache/bind
mkdir -p /var/lib/bind && chown named /var/lib/bind && lbu include /var/lib/bind
lbu include /var/lib/dhcp
mkdir -p /var/log/bind && chown named /var/log/bind && lbu include /var/log/bind
11. lbu commit
12. poweroff
13. sudo kpartx -av mykvm.config
14. mkdir -p mykvm
15. sudo mount /dev/mapper/loop0p1 mykvm -o loop,ro
16. rm -rf k8s-lb-seed/localhost.apkovl/* && tar -xvzf mykvm/localhost.apkovl.tar.gz -C k8s-lb-seed/localhost.apkovl/
17. sudo umount mykvm
18. sudo kpartx -dv /dev/loop0
19. sudo losetup -dv /dev/loop0
20. cd ~/dataStore/hyper-v/vm-configs/k8s-lb/localhost.apkovl && tar -czf ../localhost.apkovl.tar.gz *
cd ~/dataStore/hyper-v/vm-configs/k8s-lb/ && genisoimage -o seed.iso -joliet -rock ./localhost.apkovl.tar.gz k8s-lb-seed
cp seed.iso /mnt/c/Users/<user>/Downloads/k8s-lb-seed.iso

1. cd ~/dataStore/hyper-v/vm-configs/alpine/localhost.apkovl && tar -czf ../localhost.apkovl.tar.gz * && cd ../..

1. genisoimage -o ./k8s-lb/seed.iso -joliet -rock ./alpine/localhost.apkovl.tar.gz ./k8s-lb/setup-alpine-seed && cp ./k8s-lb/seed.iso /mnt/c/Users/<user>/Downloads/k8s-lb-seed.iso
genisoimage -o ./k8s-control-0/seed.iso -joliet -rock ./alpine/localhost.apkovl.tar.gz ./k8s-control-0/setup-alpine-seed && cp ./k8s-control-0/seed.iso /mnt/c/Users/<user>/Downloads/k8s-control-0-seed.iso
genisoimage -o ./k8s-control-1/seed.iso -joliet -rock ./alpine/localhost.apkovl.tar.gz ./k8s-control-1/setup-alpine-seed && cp ./k8s-control-1/seed.iso /mnt/c/Users/<user>/Downloads/k8s-control-1-seed.iso
genisoimage -o ./k8s-control-2/seed.iso -joliet -rock ./alpine/localhost.apkovl.tar.gz ./k8s-control-2/setup-alpine-seed && cp ./k8s-control-2/seed.iso /mnt/c/Users/<user>/Downloads/k8s-control-2-seed.iso

cd ~/dataStore/terraform/hyperv-test/

1. cd ~/downloads
2. mkdir alpine-virt-3.16.2-x86_64 && bsdtar -C alpine-virt-3.16.2-x86_64 -xf /mnt/c/Users/<user>/Downloads/alpine-virt-3.16.2-x86_64.iso
mkdir alpine-extended-3.16.2-x86_64 && bsdtar -C alpine-extended-3.16.2-x86_64 -xf /mnt/c/Users/<user>/Downloads/alpine-extended-3.17.1-x86_64.iso
3. sudo cp alpine-extended-3.16.2-x86_64/apks/x86_64/python3-3.10.5-r0.apk alpine-virt-3.16.2-x86_64/apks/x86_64/
sudo chown <user>:<user> alpine-virt-3.16.2-x86_64/apks/x86_64/python3-3.10.5-r0.apk
sudo cp alpine-extended-3.16.2-x86_64/apks/x86_64/libbz2-1.0.8-r1.apk alpine-virt-3.16.2-x86_64/apks/x86_64/
sudo chown <user>:<user> alpine-virt-3.16.2-x86_64/apks/x86_64/libbz2-1.0.8-r1.apk
sudo cp alpine-extended-3.16.2-x86_64/apks/x86_64/expat-2.4.8-r0.apk alpine-virt-3.16.2-x86_64/apks/x86_64/
sudo chown <user>:<user> alpine-virt-3.16.2-x86_64/apks/x86_64/expat-2.4.8-r0.apk
sudo cp alpine-extended-3.16.2-x86_64/apks/x86_64/gdbm-1.23-r0.apk alpine-virt-3.16.2-x86_64/apks/x86_64/
sudo chown <user>:<user> alpine-virt-3.16.2-x86_64/apks/x86_64/gdbm-1.23-r0.apk
sudo cp alpine-extended-3.16.2-x86_64/apks/x86_64/xz-libs-5.2.5-r1.apk alpine-virt-3.16.2-x86_64/apks/x86_64/
sudo chown <user>:<user> alpine-virt-3.16.2-x86_64/apks/x86_64/xz-libs-5.2.5-r1.apk
sudo cp alpine-extended-3.16.2-x86_64/apks/x86_64/libgcc-11.2.1_git20220219-r2.apk alpine-virt-3.16.2-x86_64/apks/x86_64/
sudo chown <user>:<user> alpine-virt-3.16.2-x86_64/apks/x86_64/libgcc-11.2.1_git20220219-r2.apk
sudo cp alpine-extended-3.16.2-x86_64/apks/x86_64/libstdc++-11.2.1_git20220219-r2.apk alpine-virt-3.16.2-x86_64/apks/x86_64/
sudo chown <user>:<user> alpine-virt-3.16.2-x86_64/apks/x86_64/libstdc++-11.2.1_git20220219-r2.apk
sudo cp alpine-extended-3.16.2-x86_64/apks/x86_64/mpdecimal-2.5.1-r1.apk alpine-virt-3.16.2-x86_64/apks/x86_64/
sudo chown <user>:<user> alpine-virt-3.16.2-x86_64/apks/x86_64/mpdecimal-2.5.1-r1.apk
sudo cp alpine-extended-3.16.2-x86_64/apks/x86_64/readline-8.1.2-r0.apk alpine-virt-3.16.2-x86_64/apks/x86_64/
sudo chown <user>:<user> alpine-virt-3.16.2-x86_64/apks/x86_64/readline-8.1.2-r0.apk
sudo cp alpine-extended-3.16.2-x86_64/apks/x86_64/sqlite-libs-3.38.5-r0.apk alpine-virt-3.16.2-x86_64/apks/x86_64/
sudo chown <user>:<user> alpine-virt-3.16.2-x86_64/apks/x86_64/sqlite-libs-3.38.5-r0.apk
sudo cp alpine-extended-3.16.2-x86_64/apks/x86_64/APKINDEX.tar.gz alpine-virt-3.16.2-x86_64/apks/x86_64/
4. xorriso -indev /mnt/c/Users/<user>/Downloads/alpine-virt-3.16.2-x86_64.iso -report_el_torito as_mkisofs
5. xorriso -as mkisofs \
--modification-date='2022070611550700' \
-isohybrid-mbr --interval:local_fs:0s-15s:zero_mbrpt,zero_gpt:'/mnt/c/Users/<user>/Downloads/alpine-virt-3.16.2-x86_64.iso' \
-partition_cyl_align on \
-partition_offset 0 \
-partition_hd_cyl 64 \
-partition_sec_hd 32 \
--mbr-force-bootable \
-iso_mbr_part_type 0x00 \
-c '/boot/syslinux/boot.cat' \
-b '/boot/syslinux/isolinux.bin' \
-no-emul-boot \
-boot-load-size 4 \
-boot-info-table \
-eltorito-alt-boot \
-e '/boot/grub/efi.img' \
-no-emul-boot \
-boot-load-size 2880 \
-isohybrid-gpt-basdat \
-o /mnt/c/Users/<user>/Downloads/alpine-virt-3.16.2-x86_64-autoinstall.iso alpine-virt-3.16.2-x86_64/


chmod permissions
check group
    getent group named
check user
    id -u named

chown 101:102 /var/lib/bind/db.internal.example.com*