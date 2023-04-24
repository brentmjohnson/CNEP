{
  alertmanager+: {
    alertmanager+: {
      spec+: {
        externalUrl: 'https://internal.example.com/alertmanager/',
        podMetadata+: {
          labels+: {
            app: 'alertmanager',
            version: '0.25.0',
          },
        },
      },
    },
  },
  blackboxExporter+: {
    deployment+: {
      spec+: {
        template+: {
          metadata+: {
            labels+: {
              app: 'blackbox-exporter',
              version: '0.21.0',
            },
          },
        },
      },
    },
  },
  grafana+: {
    deployment+: {
      spec+: {
        template+: {
          metadata+: {
            labels+: {
              app: 'grafana',
              version: '8.5.5',
            },
          },
        },
      },
    },
  },
  kubeStateMetrics+: {
    deployment+: {
      spec+: {
        template+: {
          metadata+: {
            labels+: {
              app: 'kube-state-metrics',
              version: '2.5.0',
            },
          },
        },
      },
    },
  },
  nodeExporter+: {
    daemonset+: {
      spec+: {
        template+: {
          metadata+: {
            labels+: {
              app: 'node-exporter',
              version: '1.3.1',
            },
          },
        },
      },
    },
  },
  prometheusAdapter+: {
    deployment+: {
      spec+: {
        template+: {
          metadata+: {
            labels+: {
              app: 'prometheus-adapter',
              version: '0.9.1',
            },
          },
        },
      },
    },
  },
  prometheus+: {
    prometheus+: {
      spec+: {
        externalUrl: 'https://internal.example.com/prometheus/',
        podMetadata+: {
          annotations+: {
            'proxy.istio.io/config': |||
              # configure an env variable `OUTPUT_CERTS` to write certificates to the given folder
              proxyMetadata:
                OUTPUT_CERTS: /etc/istio-output-certs
            |||,
            'sidecar.istio.io/userVolumeMount': '[{"name": "istio-certs", "mountPath": "/etc/istio-output-certs"}]' # mount the shared volume at sidecar proxy
          },
          labels+: {
            app: 'prometheus',
            version: '2.36.1',
          },
        },
        volumes+: [
          {
            name: 'istio-certs',
            emptyDir: {
              medium: 'Memory',
            },
          },
        ],
        volumeMounts+: [
          {
            name: 'istio-certs',
            mountPath: '/etc/prom-certs/',
          },
        ],
      },
    },
  },
  prometheusOperator+: {
    deployment+: {
      spec+: {
        template+: {
          metadata+: {
            labels+: {
              app: 'prometheus-operator',
              version: '0.57.0',
            },
          },
        },
      },
    },
  },
}