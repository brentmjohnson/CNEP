// Import the library function for adding mixins
local addMixin = (import 'kube-prometheus/lib/mixin.libsonnet');

// Create your mixin
local certManagerMixin = addMixin({
  name: 'cert-manager',
  mixin: (import 'cert-manager-mixin/mixin.libsonnet') + {
    _config+:: {
      // certManagerCertExpiryDays: '21',
      // certManagerJobLabel: 'cert-manager',
      // certManagerRunbookURLPattern: 'https://gitlab.com/uneeq-oss/cert-manager-mixin/-/blob/master/RUNBOOK.md#%s',
      grafanaExternalUrl: 'https://internal.example.com/grafana',
    },
  },
});

local etcdMixin = addMixin({
  name: 'etcd',
  mixin: (import 'mixin/mixin.libsonnet') + {
    _config+:: {
      // etcd_selector: 'job=~".*etcd.*"',
      // etcd_instance_labels: 'instance',
      // scrape_interval_seconds: 30,
      // dashboard_var_refresh: 2,
      // clusterLabel: 'job',
    },
  },
});

local jaegerMixin = addMixin({
  name: 'jaeger',
  mixin: (import 'jaeger-mixin/mixin.libsonnet'),
});

local jaegerAlerts = (import 'jaeger-mixin/alerts.libsonnet').prometheusAlerts;

local cephMixin = addMixin({
  name: 'ceph',
  mixin: (import 'ceph-mixin/mixin.libsonnet') + {
    _config+:: {
      // dashboardTags: ['ceph-mixin'],
      // clusterLabel: 'cluster',
      // showMultiCluster: false,
      // CephNodeNetworkPacketDropsThreshold: 0.005,
      // CephNodeNetworkPacketDropsPerSec: 10,
    },
  },
});

local kp =
  (import 'kube-prometheus/main.libsonnet') +
  (import 'kube-prometheus/addons/all-namespaces.libsonnet') +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/addons/anti-affinity.libsonnet') +
  // (import 'kube-prometheus/addons/managed-cluster.libsonnet') +
  // (import 'kube-prometheus/addons/node-ports.libsonnet') +
  (import 'kube-prometheus/addons/static-etcd.libsonnet') +
  // (import 'kube-prometheus/addons/custom-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/external-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/pyrra.libsonnet') +
  (import 'kube-prometheus/addons/networkpolicies-disabled.libsonnet') +
  // (import 'kube-prometheus/addons/strip-limits.libsonnet') +
  {
    kubernetesControlPlane+: {
      serviceMonitorKubeControllerManager+: {
        spec+: {
          endpoints: std.map(
            function(endpoint)
              if endpoint.port == 'https-metrics' then
                endpoint {
                  metricRelabelings+: [
                    {
                      sourceLabels: ['__name__','namespace','service','name'],
                      regex: 'workqueue_depth;kube-system;kube-controller-manager-prometheus-discovery;(node|service)',
                      action: 'drop',
                    },
                  ],
                }
              else
                endpoint,
            super.endpoints
          ),
        },
      },
    },
    values+:: {
      common+: {
        platform: 'kubeadm',
        namespace: 'monitoring',
      },
      kubernetesControlPlane+: {
        kubeProxy: true,
      },
      alertmanager+: {
        config+: {
          receivers+: [
            {
              name: 'discord',
              discord_configs: [
                {
                  webhook_url: 'https://discord.com/api/webhooks/<secret>/<secret>',
                },
              ],
            },
          ],
          route+: {
            routes+: [
              {
                group_by: ['alertname', 'job'],
                group_wait: '30s',
                group_interval: '5m',
                repeat_interval: '3h',
                receiver: 'discord',
              },
            ],
          },
        },
        replicas: 1,
      },
      kubeStateMetrics+: {
        kubeRbacProxyMain:: {
          resources+: {
            limits+: {
              cpu: '80m'
            },
          },
        },
        kubeRbacProxySelf:: {
          resources+: {
            limits+: {
              cpu: '80m'
            },
          },
        },
      },
      nodeExporter+: {
        resources+: {
          limits+: {
            cpu: '500m'
          },
        },
      },
      prometheus+: {
        replicas: 1,
      },
      prometheusAdapter+: {
        replicas: 1,
      },
      grafana+: {
        resources+: {
          limits+: {
            cpu: '800m'
          },
        },
        config+: {
          sections+: {
            'auth.anonymous'+: {
              enabled: true,
            },
            security+: {
              allow_embedding: true,
            },
            server+: {
              serve_from_sub_path: true,
              root_url: 'http://localhost:30080/grafana/',
            },
          },
        },
        datasources+: [
          {
            name: 'Dashboard1',
            type: 'prometheus',
            uid: 'Dashboard1',
            access: 'proxy',
            org_id: 1,
            url: 'http://prometheus-k8s.monitoring.svc:9090',
            version: 1,
            editable: false,
          },
          {
            name: 'jaeger',
            type: 'jaeger',
            uid: 'jaeger',
            access: 'proxy',
            org_id: 1,
            url: 'http://jaeger-query.observability.svc.cluster.local:16686/jaeger',
            version: 1,
            editable: false,
            jsonData: {
              nodeGraph: {
                enabled: true,
              },
            },
          },
          {
            name: 'loki',
            type: 'loki',
            access: 'proxy',
            org_id: 1,
            url: 'http://loki-loki-distributed-query-frontend.monitoring.svc.cluster.local:3100',
            version: 1,
            editable: false,
            jsonData: {
              derivedFields: [
                {
                  datasourceUid: 'jaeger',
                  matcherRegex: '"traceparent":"[0-9a-f]{2}-([0-9a-f]{32})-[0-9a-f]{16}-[0-9a-f]{2}"',
                  name: 'traceid',
                  url: '$${__value.raw}',
                },
              ],
            },
          },
        ],
        folderDashboards+:: {
          Apisix: {
            'apisix-grafana-dashboard.json': (import '../../../ingress/monitoring/apisix-grafana-dashboard.json'),
            'apisix-ingress-controller-grafana.json': (import '../../../ingress/monitoring/apisix-ingress-controller-grafana.json'),
          },
          Calico: {
            'felix-dashboard.json': (import '../../../cluster/monitoring/felix-dashboard.json'),
            'typha-dashboard.json': (import '../../../cluster/monitoring/typha-dashboard.json'),
          },
          Cassandra: {
            'cassandra-condensed.json': (import '../../../cassandra/datastax-mcac-dashboards-0.3.1/grafana/generated-dashboards/cassandra-condensed.json'),
            'overview.json': (import '../../../cassandra/datastax-mcac-dashboards-0.3.1/grafana/generated-dashboards/overview.json'),
            'stargate.json': (import '../../../cassandra/monitoring/stargate.json'),
            'system-metrics.json': (import '../../../cassandra/datastax-mcac-dashboards-0.3.1/grafana/generated-dashboards/system-metrics.json'),
          },
          Ceph: cephMixin.grafanaDashboards,
          CertManager: certManagerMixin.grafanaDashboards,
          EtcDash: etcdMixin.grafanaDashboards,
          Istio: {
            'istio-extension-dashboard.json': (import '../../../istio/monitoring/istio-extension-dashboard.json'),
            'istio-mesh-dashboard.json': (import '../../../istio/monitoring/istio-mesh-dashboard.json'),
            'istio-performance-dashboard.json': (import '../../../istio/monitoring/istio-performance-dashboard.json'),
            'istio-service-dashboard.json': (import '../../../istio/monitoring/istio-service-dashboard.json'),
            'istio-workload-dashboard.json': (import '../../../istio/monitoring/istio-workload-dashboard.json'),
            'pilot-dashboard.json': (import '../../../istio/monitoring/pilot-dashboard.json'),
          },
          JaegerDash: jaegerMixin.grafanaDashboards,
          // K8ssandra: {
          //   'cassandra-condensed.json': (import '../../../cassandra/k8ssandra-1.5.0/charts/k8ssandra/dashboards/cassandra-condensed.json'),
          //   'overview.json': (import '../../../cassandra/k8ssandra-1.5.0/charts/k8ssandra/dashboards/overview.json'),
          //   'stargate.json': (import '../../../cassandra/k8ssandra-1.5.0/charts/k8ssandra/dashboards/stargate.json'),
          //   'system-metrics.json': (import '../../../cassandra/k8ssandra-1.5.0/charts/k8ssandra/dashboards/system-metrics.json'),
          // },
          // Kafka: {
          //   'strimzi-kafka-exporter.json': (import '../../../kafka/monitoring/strimzi-kafka-exporter.json'),
          //   'strimzi-kafka.json': (import '../../../kafka/monitoring/strimzi-kafka.json'),
          //   'strimzi-operators.json': (import '../../../kafka/monitoring/strimzi-operators.json'),
          //   'strimzi-zookeeper.json': (import '../../../kafka/monitoring/strimzi-zookeeper.json'),
          // },
          Opensearch: {
            'elasticsearch-exporter.json': (import '../../../opensearch/monitoring/elasticsearch-exporter-dashboard.json'),
          },
          Redpanda: {
            'kafka-consumer-metrics.json': (import '../../../redpanda/monitoring/Kafka-Consumer-Metrics.json'),
            'kafka-consumer-offsets.json': (import '../../../redpanda/monitoring/Kafka-Consumer-Offsets.json'),
            'kafka-topic-metrics.json': (import '../../../redpanda/monitoring/Kafka-Topic-Metrics.json'),
            'redpanda-default-dashboard.json': (import '../../../redpanda/monitoring/Redpanda-Default-Dashboard.json'),
            'redpanda-metrics-dashboard.json': (import '../../../redpanda/monitoring/redpanda-metrics-dashboard.json'),
            'redpanda-ops-dashboard.json': (import '../../../redpanda/monitoring/Redpanda-Ops-Dashboard.json'),
            'redpanda-public-metrics-dashboard.json': (import '../../../redpanda/monitoring/redpanda-public-metrics-dashboard.json'),
          },
          Scylla: {
            'scylla-manager-3-0.json': (import '../../../scylla/scylla-monitoring-scylla-monitoring-4.1.0/grafana/build/manager_3.0/scylla-manager.3.0.json'),
            'alternator-5-1.json': (import '../../../scylla/scylla-monitoring-scylla-monitoring-4.1.0/grafana/build/ver_5.1/alternator.5.1.json'),
            'scylla-advanced-5-1.json': (import '../../../scylla/scylla-monitoring-scylla-monitoring-4.1.0/grafana/build/ver_5.1/scylla-advanced.5.1.json'),
            'scylla-cql-5-1.json': (import '../../../scylla/scylla-monitoring-scylla-monitoring-4.1.0/grafana/build/ver_5.1/scylla-cql.5.1.json'),
            'scylla-cql-overview-5-1.json': (import '../../../scylla/monitoring/scylla-cql-overview.5.1.json'),
            'scylla-detailed-5-1.json': (import '../../../scylla/scylla-monitoring-scylla-monitoring-4.1.0/grafana/build/ver_5.1/scylla-detailed.5.1.json'),
            'scylla-ks-5-1.json': (import '../../../scylla/scylla-monitoring-scylla-monitoring-4.1.0/grafana/build/ver_5.1/scylla-ks.5.1.json'),
            'scylla-os-5-1.json': (import '../../../scylla/scylla-monitoring-scylla-monitoring-4.1.0/grafana/build/ver_5.1/scylla-os.5.1.json'),
            'scylla-overview-5-1.json': (import '../../../scylla/monitoring/scylla-overview.5.1.json'),
          },
        },
      },
      etcd+: {
        ips: ['10.0.0.3', '10.0.0.4', '10.0.0.5'],
        clientCA: importstr '../../../cluster/etcd/ca.crt',
        clientKey: importstr '../../../cluster/etcd/apiserver-etcd-client.key',
        clientCert: importstr '../../../cluster/etcd/apiserver-etcd-client.crt',
        // openssl x509 -in ../../cluster/etcd/ca.crt -text -noout
        serverName: 'localhost',
        // insecureSkipVerify: true,
      },
    },
  } + 
  (import '../../../monitoring/monitoring/monitoring-patch.jsonnet') +
  // {
  //   alertmanager+: monitoringPatch.alertmanager,
  //   blackboxExporter+: monitoringPatch.blackboxExporter,
  //   grafana+: monitoringPatch.grafana,
  //   kubeStateMetrics+: monitoringPatch.kubeStateMetrics,
  //   nodeExporter+: monitoringPatch.nodeExporter,
  //   prometheusAdapter+: monitoringPatch.prometheusAdapter,
  //   prometheus+: monitoringPatch.prometheus,
  //   prometheusOperator+: monitoringPatch.prometheusOperator,
  // };
  (import '../../../monitoring/monitoring/istioMtls-patch.jsonnet');

{ 'setup/0namespace-namespace': kp.kubePrometheus.namespace } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor' && name != 'prometheusRule'), std.objectFields(kp.prometheusOperator))
} +
// { 'setup/pyrra-slo-CustomResourceDefinition': kp.pyrra.crd } +
// serviceMonitor and prometheusRule are separated so that they can be created after the CRDs are ready
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ 'prometheus-operator-prometheusRule': kp.prometheusOperator.prometheusRule } +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['blackbox-exporter-' + name]: kp.blackboxExporter[name] for name in std.objectFields(kp.blackboxExporter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
// { ['pyrra-' + name]: kp.pyrra[name] for name in std.objectFields(kp.pyrra) if name != 'crd' } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) }
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
// MIXIN SPECIFIC CRDS
{ 'cert-manager-mixin': certManagerMixin.prometheusAlerts } +
{ 'cert-manager-mixin': certManagerMixin.prometheusRules } +
{ 'mixin': etcdMixin.prometheusRules } +
{ 'jaeger-mixin': jaegerMixin.prometheusRules }
// Removing as PrometheusRules are handled by rook
//{ 'ceph-mixin': cephMixin.prometheusRules }