1. rocksdb: submit_common error: Corruption: block checksum mismatch:
2. ceph health
3. ceph osd tree | grep -i down
4. kubectl -n rook-ceph patch CephCluster/rook-ceph --type=json -p '[{"op": "replace", "path": "/spec/storage/storageClassDeviceSets/0/count", "value":2}]'
5. kubectl -n rook-ceph get pvc -l ceph.rook.io/DeviceSet=set1
    set1-data-14wkfw
6. kubectl -n rook-ceph get pod -l ceph.rook.io/pvc=set1-data-14wkfw -o yaml | grep ceph-osd-id
    ceph-osd-id: "1"
7. kubectl -n rook-ceph scale deployment rook-ceph-osd-1 --replicas=0
8. ceph osd down osd.1
9. kubectl create -f ./rook/osd-purge-osd.1.yaml
10. kubectl delete -f ./rook/osd-purge-osd.1.yaml
11. alt
    1. ceph osd out osd.1
    2. while ! ceph osd safe-to-destroy osd.1; do sleep 10 ; done
    3. ceph status
    4. ceph osd purge 1 --yes-i-really-mean-it
    5. ceph osd tree
    6. kubectl patch -n rook-ceph CephCluster/rook-ceph --type=merge -p '{"spec":{"removeOSDsIfOutAndSafeToRemove":true}}'
12. kubectl delete deployment -n rook-ceph rook-ceph-osd-1
13. kubectl delete pvc -n rook-ceph set1-data-3skgrg
14. sudo rm -rf /var/lib/rook/
15. sudo sgdisk --zap-all /dev/sdc
sudo dd if=/dev/zero of=/dev/sdc bs=4M count=1
sudo blkdiscard -f /dev/sdc
sudo partprobe /dev/sdc

14. kubectl apply -f ./rook/cluster-on-local-pvc.yaml

