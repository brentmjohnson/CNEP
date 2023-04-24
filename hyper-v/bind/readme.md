apk update && apk add bind
mkdir -p /var/cache/bind && chown named /var/cache/bind
mkdir -p /var/lib/bind && chown named /var/lib/bind
mkdir -p /var/log/bind && chown named /var/log/bind
named-checkconf
rc-update add named
rc-service named start
apk add dnsmasq-dnssec

rc-service dnsmasq stop
rm /var/lib/misc/dnsmasq.leases
rc-service dnsmasq start

journalctl -f | grep -Ei 'dhclient'
sudo dhclient eth0

resolvectl dns

networkctl status eth0
sudo dhclient -6 -r -v
rc-service dhcpd6 stop
rm /var/lib/dhcp/dhcpd6.*
rc-service dhcpd6 start
sudo dhclient -6 -v

# dynamic updates
rndc freeze internal.example.com
vi /var/lib/bind/db.internal.example.com
_acme-challenge     120 TXT     DQ0I-WlazXfaNj1etLOQ_lQq8iyBgjHRzMF-x-lYvaY
_acme-challenge     120 TXT     wsuDqUPyphkjsxW-FX2Gf61xEmcWifBqwROIiEvT3bs
rndc reload internal.example.com
rndc thaw internal.example.com

dig +noall +answer +multiline _acme-challenge.internal.example.com txt

nsupdate -k /etc/bind/rndc.key
nsupdate -y hmac-sha256:ns-internal-example-com-rndc-key:NYmxDOr4Bwm/dprIqOSCeSSrvCOAoEdNZy1iJBFP4WA= -D
nsupdate -y hmac-sha256:rndc-key:NYmxDOr4Bwm/dprIqOSCeSSrvCOAoEdNZy1iJBFP4WA= -D
update add www1.internal.example.com 60 txt testing
send
dig +noall +answer +multiline www1.internal.example.com txt
update delete www1.internal.example.com txt
send

kubectl -n cert-manager create secret generic bind9-tsig-secret --from-literal=tsig-secret-key=NYmxDOr4Bwm/dprIqOSCeSSrvCOAoEdNZy1iJBFP4WA=

update delete *.internal.example.com. A

clear bind cache:
rndc flush