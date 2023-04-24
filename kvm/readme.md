1. https://fabianlee.org/2018/08/27/kvm-bare-metal-virtualization-on-ubuntu-with-kvm/
2. sudo apt install qemu-system-x86 qemu-kvm qemu libvirt-dev libvirt-clients virt-manager virtinst bridge-utils cpu-checker virt-viewer -y
3. $ sudo kvm-ok

INFO: /dev/kvm exists
KVM acceleration can be used
4. # if this fails, you may have an older version still installed
virt-host-validate --version

# the newest version comes from /usr/bin (not /usr/local/bin)
which virt-host-validate

# this utility comes from the libvirt-clients package
sudo virt-host-validate

5. # append these settings to avoid AppArmor issues
echo 'security_driver = "none"' | sudo tee -a /etc/libvirt/qemu.conf
echo 'namespaces = []' | sudo tee -a /etc/libvirt/qemu.conf

# make qemu:///system available to group, not just root
echo 'unix_sock_group = "libvirt"' | sudo tee -a /etc/libvirt/libvirtd.conf

sudo service libvirtd restart
sudo journalctl -u libvirtd.service --no-pager

# should be 'active' after restart
sudo service libvirtd status

6. # add self to libvirt related groups
cat /etc/group | grep libvirt | awk -F':' {'print $1'} | xargs -n1 sudo adduser $USER

# add user to kvm group also
sudo adduser $USER kvm

# relogin, then show group membership
exec su -l $USER
id | grep libvirt

# fix file permissions
sudo chown root:kvm /dev/kvm
sudo chmod 660 /dev/kvm


# download clouding image if needed
wget https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img
# check dmesg
dmesg | grep -i kvm
dmesg | grep -i iommu
4. sudo qemu-system-x86_64 \
-machine accel=kvm,type=q35 \
-cpu host \
-smp 2 \
-m 2048 \
-vga qxl \
-drive if=virtio,format=qcow2,file=ubuntu-22.04-server-cloudimg-amd64.img \
--enable-kvm

-drive file=ubuntu-22.04.1-desktop-amd64.iso,media=cdrom,readonly=on \

,+3dnowprefetch,+abm,+adx,+aes,+amd-ssbd,+amd-stibp,+apic,+arat,+arch-capabilities,+avx,+avx2,+bmi1,+bmi2,+clflush,+clflushopt,+clwb,+clzero,+cmov,+cmp-legacy,+cr8legacy,+cx16,+cx8,+de,+erms,+f16c,+fma,+fpu,+fsgsbase,+fsrm,+fxsr,+fxsr-opt,+hypervisor,+ibpb,+ibrs,+invpcid,+invtsc,+kvm-asyncpf,+kvm-asyncpf-int,+kvm-hint-dedicated,+kvm-nopiodelay,+kvm-poll-control,+kvm-pv-eoi,+kvm-pv-ipi,+kvm-pv-sched-yield,+kvm-pv-tlb-flush,+kvm-pv-unhalt,+kvm-steal-time,+kvmclock,+kvmclock,+kvmclock-stable-bit,+lahf-lm,+lm,+mca,+mce,+mds-no,+misalignsse,+mmx,+mmxext,+movbe,+msr,+mtrr,+npt,+nrip-save,+nx,+osvw,+pae,+pat,+pclmulqdq,+pdpe1gb,+pge,+pni,+popcnt,+pschange-mc-no,+pse,+pse36,+rdctl-no,+rdpid,+rdrand,+rdseed,+rdtscp,+sep,+sha-ni,+skip-l1dfl-vmentry,+smap,+smep,+spec-ctrl,+ssbd,+sse,+sse2,+sse4.1,+sse4.2,+sse4a,+ssse3,+stibp,+svm,+svme-addr-chk,+syscall,+topoext,+tsc,+tsc-adjust,+tsc-deadline,+umip,+vaes,+virt-ssbd,+vme,+vpclmulqdq,+x2apic,+xgetbv1,+xsave,+xsavec,+xsaveerptr,+xsaveopt,+xsaves

# start libvirtd on wsl start
sudo libvirtd -d && sudo virtlogd -d

create /etc/init.d/libvirtd from this: https://www.apt-browse.org/browse/ubuntu/bionic/main/amd64/libvirt-daemon-system/4.0.0-1ubuntu8/file/etc/init.d/libvirtd

create /etc/init.d/virtlogd from this: 

sudo sed -i 's/#start_libvirtd=no/start_libvirtd=yes/g' /etc/default/libvirtd

update /etc/wsl.conf section to the following:
[boot]
command="service docker start && \
service virtlogd start && \
service libvirtd start && \
chown root:kvm /dev/kvm && chmod 660 /dev/kvm"

service --status-all