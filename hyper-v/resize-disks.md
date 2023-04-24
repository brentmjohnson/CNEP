https://learn.microsoft.com/en-us/windows/wsl/disk-space
1. shutdown hyper-v vms
2. 

1. sudo mount -t devtmpfs none /dev
mount | grep ext4
2. fdisk -l
cat /proc/partitions
3. 
2. lvextend -l +100%FREE /dev/vg0/lv_root

# after the virtual disk has already been expanded (e.g. in proxmox)

apk add --no-cache lsblk cfdisk growpart e2fsprogs-extra

# choose partition then "Resize" > "Write" (to finalize)
cfdisk

pvresize /dev/sda2

lvextend -l+100%FREE /dev/vg0/lv_root

# replace * with partition you are resizing
resize2fs /dev/mapper/vg0-lv_root

# Ubuntu 22.04
1. expand from hyper-v manager
2. sudo growpart /dev/sda 4
3. sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
4. sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv