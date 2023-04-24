1. helm repo add metallb https://metallb.github.io/metallb
helm repo update metallb

https://www.reddit.com/r/homelab/comments/ipsc4r/howto_k8s_metallb_and_external_dns_access_for/
https://coredns.io/plugins/k8s_external/#description
https://particule.io/en/blog/k8s-no-cloud/
https://github.com/kubernetes-sigs/external-dns/blob/7b8c69b22e33e04041c3a8299e13cab4f44ad486/docs/tutorials/coredns.md
https://github.com/kubernetes-sigs/external-dns/blob/35f2594745d6955625c47d7c46029cf1cb639154/docs/tutorials/rfc2136.md

apk add dhcp

rc-service dnsmasq stop
rm /var/lib/misc/dnsmasq.leases
rc-service dnsmasq start
rndc querylog
sudo dhclient -4 -r

<!-- calicoctl apply -f - <<EOF
apiVersion: projectcalico.org/v3
kind: IPPool
metadata:
  name: external-loadbalancer-pool
spec:
  cidr: 10.0.0.0/24
  blockSize: 32
  ipipMode: Never
  vxlanMode: CrossSubnet
  natOutgoing: true
  nodeSelector: "!all()"
--- -->

2. calicoctl apply -f - <<EOF
apiVersion: projectcalico.org/v3
kind: BGPConfiguration
metadata:
  name: default
spec:
  asNumber: <asn>
  nodeToNodeMeshEnabled: false
  serviceLoadBalancerIPs:
  - cidr: 10.0.1.0/24
---
apiVersion: projectcalico.org/v3
kind: BGPPeer
metadata:
  name: unifi-usg-peer
spec:
  peerIP: <host>
  asNumber: <asn>
EOF

3. ansible-playbook ./ansible/hyperv-k8s-provisioner/33_install_metalLB.yml -i ./ansible/hyperv-k8s-provisioner/k8s-setup/clusters/k8s/k8s-inventory-k8s

4. kubectl delete daemonset.apps/speaker -n metallb-system

5. https://community.ui.com/questions/How-to-configure-BGP-routing-on-USG-Pro-4/ecdfecb5-a8f5-48a5-90da-cc68d054be11#answer/2e8a41f7-622c-433e-bddd-4d283d95aa4f

6. kubectl create deployment nginx --image=nginx
kubectl create service loadbalancer nginx --tcp 80:80
kubectl patch service nginx --type merge --patch '{"spec":{"externalTrafficPolicy": "Local"}}'
kubectl patch deployment nginx --type merge --patch '{"spec":{"template":{"spec":{"tolerations": [
{
  "effect": "NoExecute",
  "key": "node.kubernetes.io/not-ready",
  "operator": "Exists",
  "tolerationSeconds": 5
},
{
  "effect": "NoExecute",
  "key": "node.kubernetes.io/unreachable",
  "operator": "Exists",
  "tolerationSeconds": 5
}
]}}}}'
kubectl scale deployment nginx --replicas=2

tolerations:
  - effect: NoExecute
    key: node.kubernetes.io/not-ready
    operator: Exists
    tolerationSeconds: 300
  - effect: NoExecute
    key: node.kubernetes.io/unreachable
    operator: Exists
    tolerationSeconds: 300

7. kubectl apply -f - <<EOF
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: ip-pool
  namespace: metallb-system
spec:
  addresses:
  - 10.0.1.0/24
  avoidBuggyIPs: true
EOF

8. https://community.ui.com/questions/USG-BGP-Multipating-Commit-Error/72d810e6-477a-44ef-8ecb-153c310de257#answer/0275e89a-b6db-4050-8a3e-87c6dfc7a897
cat /opt/vyatta/sbin/vyatta-bgp.pl | grep -n "max-paths"

138:      set => 'router bgp #3 ; max-paths ebgp #6',
139:      del => 'router bgp #3 ; no max-paths ebgp #6',
142:      set => 'router bgp #3 ; max-paths ibgp #6',
143:      del => 'router bgp #3 ; no max-paths ibgp #6',

sudo vi /opt/vyatta/sbin/vyatta-bgp.pl

cat /opt/vyatta/sbin/vyatta-bgp.pl | grep -n "maximum-paths"

133:  'protocols bgp var maximum-paths' => {
137:  'protocols bgp var maximum-paths ebgp' => {
138:      set => 'router bgp #3 ; maximum-paths #6',
139:      del => 'router bgp #3 ; no maximum-paths #6',
141:  'protocols bgp var maximum-paths ibgp' => {
142:      set => 'router bgp #3 ; maximum-paths ibgp #6',
143:      del => 'router bgp #3 ; no maximum-paths ibgp #6',

OVERVIEW
MAC Address	<mac>
Model	USG-3P
Version	4.4.56.5449062
IP Address (LAN)	<host>
Uptime	21h 18m 28s

cat /opt/vyatta/sbin/vyatta-bgp.pl | grep -n "bestpath"

549:  'protocols bgp var parameters bestpath' => {
553:  'protocols bgp var parameters bestpath as-path' => {
557:  'protocols bgp var parameters bestpath as-path confed' => {
558:      set => 'router bgp #3 ; bgp bestpath compare-confed-aspath',
559:      del => 'router bgp #3 ; no bgp bestpath compare-confed-aspath',
561:  'protocols bgp var parameters bestpath as-path ignore' => {
562:      set => 'router bgp #3 ; bgp bestpath as-path ignore',
563:      del => 'router bgp #3 ; no bgp bestpath as-path ignore',
565:  'protocols bgp var parameters bestpath compare-routerid' => {
566:      set => 'router bgp #3 ; bgp bestpath compare-routerid',
567:      del => 'router bgp #3 ; no bgp bestpath compare-routerid',
569:  'protocols bgp var parameters bestpath med' => {
573:  'protocols bgp var parameters bestpath med confed' => {
574:      set => 'router bgp #3 ; bgp bestpath med confed',
575:      del => 'router bgp #3 ; no bgp bestpath med confed',
577:  'protocols bgp var parameters bestpath med missing-as-worst' => {
578:      set => 'router bgp #3 ; bgp bestpath med missing-as-worst',
579:      del => 'router bgp #3 ; no bgp bestpath med missing-as-worst',

fuck ubiquiti ECMP doesnt work: https://www.reddit.com/r/Ubiquiti/comments/jwcvdl/comment/gcsr58d/?utm_source=share&utm_medium=web2x&context=3