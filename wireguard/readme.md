1. ssh <user>@<host> "sudo -S cat /usr/lib/unifi/data/sites/default/config.gateway.json" > ./wireguard/config.gateway.json
ssh <user>@<host> "sudo -S cat /usr/lib/unifi/data/sites/default/config.gateway.json" > ./wireguard/config.gateway.json

ssh <user>@<host> "mca-ctrl -t dump-cfg" > ./wireguard/config.dmp
mca-ctrl -t dump-cfg

2. scp pi@raspberrypi:/usr/lib/unifi/data/sites/default/config.gateway.json ./wireguard/config.gateway.json
scp ./wireguard/config.gateway.json pi@raspberrypi:/usr/lib/unifi/data/sites/default/config.gateway.json

3. curl -OL https://github.com/WireGuard/wireguard-vyatta-ubnt/releases/download/1.0.20220627-1/ugw3-v1-v1.0.20220627-v1.0.20210914.deb
4. sudo dpkg -i ugw3-v1-v1.0.20220627-v1.0.20210914.deb

./decrypt.sh /mnt/c/Users/<user>/Downloads/network_backup_09.19.2022_06-49-PM_v7.2.92.unf /mnt/c/Users/<user>/Downloads/network_backup_09.19.2022_06-49-PM_v7.2.92.zip

https://www.technowizardry.net/2022/01/wireguard-vpn-to-dedicated-servers/#MSSClampingConfig
https://www.perdian.de/blog/2022/02/21/setting-up-a-wireguard-vpn-using-kubernetes/

# Unifi
1. show firewall
2. netstat -r
3. mca-ctrl -t dump-cfg
4. curl -OL https://github.com/WireGuard/wireguard-vyatta-ubnt/releases/download/${RELEASE}/${BOARD}-${RELEASE}.deb

configure
set interfaces wireguard wg0 route-allowed-ips false
set interfaces wireguard wg1 route-allowed-ips false
set interfaces wireguard wg2 route-allowed-ips false
set interfaces wireguard wg3 route-allowed-ips false
commit
delete interfaces wireguard
commit
sudo rmmod wireguard
sudo dpkg -i ${BOARD}-${RELEASE}.deb
sudo modprobe wireguard
load
commit
exit
5. configure
set protocols static route 10.0.0.0/24 next-hop <ip> distance 1
set protocols static interface-route 10.0.0.0/24 next-hop-interface wg1
delete protocols static route 10.0.0.0/24
commit
save
exit

show load-balance status
show load-balance watchdog
show load-balance config

show ip route
show ip route table 201
show ip route table 202
show ip route table 202

clear connection-tracking

# Wireguard
1. kubectl create namespace wireguard
2. kubectl apply -f ./wireguard/wireguard-secret.yaml
3. kubectl apply -f ./wireguard/wireguard-deployment.yaml

https://community.ui.com/questions/Multiple-wireguard-clients-for-VPN-failover-load-balance/da44e945-e640-408b-a4e1-cc6183da1a8b
https://help.ui.com/hc/en-us/articles/205145990-EdgeRouter-WAN-Load-Balancing


"sticky": {
    "dest-addr": "enable",
    "dest-port": "enable",
    "source-addr": "enable"
}

configure
set policy route-map wg2-routes rule 10 action permit
set policy route-map wg2-routes rule 10 set ip-next-hop <ip>
set protocols bgp <asn> neighbor 10.0.0.4 route-map import wg2-routes
commit
save
run clear ip bgp all soft
exit
mca-ctrl -t dump-cfg