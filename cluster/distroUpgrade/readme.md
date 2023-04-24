https://help.ubuntu.com/community/EOLUpgrades#Update_sources.list
1. docker cp ./cluster/distroUpgrade/sources.list k8s-0-worker:/etc/apt/sources.list
2. apt update && dpkg --configure -a
3. apt --fix-broken install
3. dpkg -P linux-headers-5.13.0-52-generic
4. apt install linux-headers-5.13.0-52-generic
3. apt install update-manager-core pciutils
4. apt dist-upgrade
5. mount -o remount,exec /tmp
6. do-release-upgrade
7. restart
8. apt update
9. apt dist-upgrade

docker exec -it containerID sh