{
  alertmanager+: {
    serviceMonitor+: {
      spec+: {
        endpoints: [
          {
            interval: '30s',
            port: 'web',
            scheme: 'http',
            tlsConfig: {
              caFile: '/etc/prom-certs/root-cert.pem',
              certFile: '/etc/prom-certs/cert-chain.pem',
              keyFile: '/etc/prom-certs/key.pem',
              insecureSkipVerify: true,
            },
          },
          {
            interval: '30s',
            port: 'reloader-web',
            scheme: 'https',
            tlsConfig: {
              caFile: '/etc/prom-certs/root-cert.pem',
              certFile: '/etc/prom-certs/cert-chain.pem',
              keyFile: '/etc/prom-certs/key.pem',
              insecureSkipVerify: true,
            },
          },
        ],
      },
    },
    service+: {
      spec+: {
        ports: [
          { name: 'web', targetPort: 'web', port: 9093 },
          { name: 'reloader-web', port: 8080, targetPort: 'reloader-web', appProtocol: 'http' },
        ],
      },
    },
  },
  blackboxExporter+: {
    deployment+: {
      spec+: {
        template+: {
          metadata+: {
            annotations+: {
              "traffic.sidecar.istio.io/excludeInboundPorts": "9115",
            },
          },
        },
      },
    },
  },
  grafana+: {
    serviceMonitor+: {
      spec+: {
        endpoints: [
          {
            interval: '15s',
            port: 'http',
            scheme: 'https',
            tlsConfig: {
              caFile: '/etc/prom-certs/root-cert.pem',
              certFile: '/etc/prom-certs/cert-chain.pem',
              keyFile: '/etc/prom-certs/key.pem',
              insecureSkipVerify: true,
            },
          },
        ],
      },
    },
  },
  prometheusAdapter+: {
    deployment+: {
      spec+: {
        template+: {
          metadata+: {
            annotations+: {
              "traffic.sidecar.istio.io/excludeInboundPorts": "6443",
            },
          },
        },
      },
    },
  },
}