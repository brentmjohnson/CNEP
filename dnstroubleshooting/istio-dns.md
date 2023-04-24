sudo crictl inspect 4c6c9dbc3d19bb5580b4c95caca64d8d261d94a4c005818fbde5c87c53f7d833

443799

sudo nsenter -t 443799 -n iptables -L -t nat -n -v --line-numbers -x