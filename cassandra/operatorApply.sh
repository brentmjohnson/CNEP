cat <<EOF | kubectl -n k8ssandra-operator apply -f -
apiVersion: k8ssandra.io/v1alpha1
kind: K8ssandraCluster
metadata:
  name: cassandra
spec:
  reaper:
    autoScheduling:
      enabled: true
      repairType: INCREMENTAL
    cassandraUserSecretRef:
      name: reaper-secret
    jmxUserSecretRef:
      name: reaper-jmx-secret
    uiUserSecretRef:
      name: reaper-ui-secret
    heapSize: 512M
  medusa:
    cassandraUserSecretRef:
      name: medusa-secret
    storageProperties:
      storageProvider: s3_compatible
      storageSecretRef:
        name: medusa-bucket-key
      bucketName: k8ssandra-medusa-bucket-3f5e3e33-066d-4d2c-9610-327df49495d7
      prefix: cassandra
      host: rook-ceph-rgw-my-store.rook-ceph.svc.cluster.local
      port: 80
      secure: false
  cassandra:
    serverVersion: "4.0.4"
    telemetry: 
      prometheus:
        enabled: true
    datacenters:
      - metadata:
          name: dc1
        size: 1
        softPodAntiAffinity: true
        racks:
          - name: default
        storageConfig:
          cassandraDataVolumeClaimSpec:
            # storageClassName: standard
            accessModes:
              - ReadWriteOnce
            resources:
              requests:
                storage: 5Gi
        config:
          jvmOptions:
            heapSize: 512M
        # heap:
        #   size: 512M
        #   newGenSize: 512M
        resources:
          limits:
            # cpu: 1000m
            memory: 1024M
          requests:
            cpu: 1000m
            memory: 1024M
        stargate:
          telemetry: 
            prometheus:
              enabled: true
          size: 1
          heapSize: 256M
          resources:
            limits:
              cpu: 1000m
              memory: 512M
            requests:
              cpu: 1000m
              memory: 512M
          allowStargateOnDataNodes: true
          # affinity:
          #   podAntiAffinity:
          #     preferredDuringSchedulingIgnoredDuringExecution:
          #       - weight: 100
          #         podAffinityTerm:
          #           labelSelector:
          #             matchExpressions:
          #               - key: cassandra.datastax.com/cluster
          #                 operator: In
          #                 values:
          #                   - cassandra
          #               - key: cassandra.datastax.com/datacenter
          #                 operator: In
          #                 values:
          #                   - dc1
          #               - key: cassandra.datastax.com/rack
          #                 operator: In
          #                 values:
          #                   - default
          #           namespaces:
          #             - k8ssandra-operator
          #           topologyKey: kubernetes.io/hostname
EOF