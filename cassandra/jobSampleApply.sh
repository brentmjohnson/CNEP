cat <<EOF | kubectl -n k8ssandra-operator apply -f -
{
   "apiVersion": "batch/v1",
   "kind": "Job",
   "metadata": {
      "name": "cassandra-dc1-reaper-init"
   },
   "spec": {
      "template": {
         "spec" {
            "containers": [
               {
  "args": [
    "schema-migration"
  ],
  "env": [
    {
      "name": "REAPER_STORAGE_TYPE",
      "value": "cassandra"
    },
    {
      "name": "REAPER_ENABLE_DYNAMIC_SEED_LIST",
      "value": "false"
    },
    {
      "name": "REAPER_CASS_CONTACT_POINTS",
      "value": "[cassandra-dc1-service]"
    },
    {
      "name": "REAPER_DATACENTER_AVAILABILITY",
      "value": "ALL"
    },
    {
      "name": "REAPER_CASS_LOCAL_DC",
      "value": "dc1"
    },
    {
      "name": "REAPER_CASS_KEYSPACE",
      "value": "reaper_db"
    },
    {
      "name": "REAPER_AUTO_SCHEDULING_ENABLED",
      "value": "true"
    },
    {
      "name": "REAPER_AUTO_SCHEDULING_ADAPTIVE",
      "value": "false"
    },
    {
      "name": "REAPER_AUTO_SCHEDULING_INCREMENTAL",
      "value": "true"
    },
    {
      "name": "REAPER_AUTO_SCHEDULING_PERCENT_UNREPAIRED_THRESHOLD",
      "value": "10"
    },
    {
      "name": "REAPER_AUTO_SCHEDULING_INITIAL_DELAY_PERIOD",
      "value": "PT15S"
    },
    {
      "name": "REAPER_AUTO_SCHEDULING_PERIOD_BETWEEN_POLLS",
      "value": "PT10M"
    },
    {
      "name": "REAPER_AUTO_SCHEDULING_TIME_BEFORE_FIRST_SCHEDULE",
      "value": "PT5M"
    },
    {
      "name": "REAPER_AUTO_SCHEDULING_SCHEDULE_SPREAD_PERIOD",
      "value": "PT6H"
    },
    {
      "name": "REAPER_HEAP_SIZE",
      "value": "2147483648"
    },
    {
      "name": "REAPER_CASS_AUTH_ENABLED",
      "value": "true"
    },
    {
      "name": "REAPER_CASS_AUTH_USERNAME",
      "valueFrom": {
        "secretKeyRef": {
          "key": "username",
          "name": "reaper-secret"
        }
      }
    },
    {
      "name": "REAPER_CASS_AUTH_PASSWORD",
      "valueFrom": {
        "secretKeyRef": {
          "key": "password",
          "name": "reaper-secret"
        }
      }
    },
    {
      "name": "REAPER_JMX_AUTH_USERNAME",
      "valueFrom": {
        "secretKeyRef": {
          "key": "username",
          "name": "reaper-jmx-secret"
        }
      }
    },
    {
      "name": "REAPER_JMX_AUTH_PASSWORD",
      "valueFrom": {
        "secretKeyRef": {
          "key": "password",
          "name": "reaper-jmx-secret"
        }
      }
    },
    {
      "name": "REAPER_AUTH_ENABLED",
      "value": "true"
    },
    {
      "name": "REAPER_AUTH_USER",
      "valueFrom": {
        "secretKeyRef": {
          "key": "username",
          "name": "reaper-ui-secret"
        }
      }
    },
    {
      "name": "REAPER_AUTH_PASSWORD",
      "valueFrom": {
        "secretKeyRef": {
          "key": "password",
          "name": "reaper-ui-secret"
        }
      }
    }
  ],
  "image": "docker.io/thelastpickle/cassandra-reaper:3.1.1",
  "imagePullPolicy": "IfNotPresent",
  "name": "reaper-schema-init",
  "resources": {},
  "terminationMessagePath": "/dev/termination-log",
  "terminationMessagePolicy": "File"
}
            ]
         }
      }
   }
}
EOF