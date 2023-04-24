$TTL 60 ; 1 minute
@                               IN SOA  ns.internal.example.com. admin.example.com. (
                                        2023011001 ; serial
                                        60         ; refresh (1 minute)
                                        60         ; retry (1 minute)
                                        60         ; expire (1 minute)
                                        60         ; minimum (1 minute)
                                        )
                                NS      ns.internal.example.com.
ns                              A       10.0.0.2
                                AAAA    fd11::10:0:0:2
k8s-lb                          CNAME   ns
_acme-challenge                 NS      ens.external.example.com
ens.external.example.com        A       <host>
                                AAAA    <host>
                                A       <host>
                                AAAA    <host>
