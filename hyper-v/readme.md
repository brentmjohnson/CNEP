https://www.subnetonline.com/pages/subnet-calculators/ipv4-to-ipv6-converter.php

# networking (nat-ed subnet):
1. https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/setup-nat-network
2. New-VMSwitch -SwitchName "K8s-0" -SwitchType Internal
3. $ifIndex = (Get-NetAdapter -Name "vEthernet (k8s)").ifIndex
Remove-NetIPAddress -InterfaceAlias "vEthernet (k8s)" -Confirm:$false
New-NetIPAddress -AddressFamily IPv4 -IPAddress 10.0.0.1 -PrefixLength 24 -InterfaceIndex $ifIndex
New-NetIPAddress -AddressFamily IPv6 -IPAddress fd11::10:0:0:1 -PrefixLength 118 -InterfaceIndex $ifIndex
Remove-NetNat -Name k8s-* -A
New-NetNat -Name k8s-IPv4 -InternalIPInterfaceAddressPrefix 10.0.0.0/24
New-NetNat -Name k8s-IPv6 -InternalIPInterfaceAddressPrefix fd11::10:0:0:0/118
Set-NetIPInterface -ifAlias "vEthernet (WSL)" -Forwarding Enabled
Set-NetIPInterface -ifAlias "vEthernet (k8s)" -Forwarding Enabled
Get-NetIPInterface | select ifIndex,InterfaceAlias,AddressFamily,ConnectionState,Forwarding | Sort-Object -Property IfIndex | Format-Table

# networking (add vm to nat-ed subnet)
1. https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/setup-nat-network#connect-a-virtual-machine
2. echo "k8s-0-control-0" > /etc/hostname
3. hostname -F /etc/hostname
<!-- 4. modprobe ipv6
echo "ipv6" >> /etc/modules -->
4. vi /etc/resolv.conf
nameserver  <host>
4. vi /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0

iface eth0 inet dhcp

iface eth0 inet static
        address 10.0.0.2
        netmask 255.255.255.0
        gateway 10.0.0.1

iface eth0 inet6 static
        address fd11:10:0:0::2
        netmask 64
        gateway fd11:10:0:0::1
        pre-up echo 0 > /proc/sys/net/ipv6/conf/eth0/accept_ra
5. /etc/init.d/networking restart

host -t AAAA Unifi-USG

sudo netplan apply

minikube start --nodes 4 --memory 4GB --driver=hyperv 

1. cd "C:\Program Files\Oracle\VirtualBox"
2. VBoxManage convertfromraw "C:\Users\<user>\Downloads\alpine-virt-3.16.2-x86_64.iso" "C:\Users\<user>\Downloads\alpine-virt-3.16.2-x86_64.vmdk"
3. VBoxManage convertfromraw "C:\Users\<user>\Downloads\alpine-virt-3.16.2-x86_64.iso" "C:\Users\<user>\Downloads\alpine-virt-3.16.2-x86_64.vhd"
4. Convert-VHD -Path "C:\K8sImages\k8s-0(alpine)\k8s-0-control-0\k8s-0-control-0.vhd" -DestinationPath "C:\K8sImages\k8s-0(alpine)\k8s-0-control-0\k8s-0-control-0.vhdx"

vi /etc/ssh/sshd_config
PermitEmptyPasswords yes
/etc/init.d/sshd restart

echo 'root:root'|chpasswd

# ssh config
1. cat ~/.ssh/id_rsa.pub | ssh <user>@10.0.0.3 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

# copied vm steps
1. sudo hostnamectl set-hostname k8s-0-worker-2
2. echo '# This is the network config written by 'subiquity'
network:
  ethernets:
    eth0:
      addresses:
      - 10.0.0.8/24
      - fd11:10::8/64
      gateway4: 10.0.0.1
      gateway6: fd11:10::1
      nameservers:
        addresses:
        - <host>
        - <host>
        - <host>
        - <host>
        search: []
  version: 2' | sudo tee /etc/netplan/00-installer-config.yaml
3. sudo echo '127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters


10.0.0.8 k8s-0-worker-2
fd11:10::8 k8s-0-worker-2' | sudo tee /etc/hosts