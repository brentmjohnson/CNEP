{
  cephMixin+: {
    prometheusRules+: {
      spec+: {
        groups: std.map(
          function(group)
            if group.name == 'PrometheusServer' then
              group {
                rules: std.filter(
                  function(rule)
                    rule.alert != 'PrometheusJobMissing',
                  group.rules
                ),
              }
            else
              group,
          super.groups
        ),
      },
    },
  },
}