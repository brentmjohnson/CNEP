Apisix_test_realm Frontend URL: http://keycloak-service.keycloak-operator.svc.cluster.local:8080/keycloak/

Testing:
curl -k --request POST \
  --url 'https://10.0.0.2/keycloak/realms/apisix/protocol/openid-connect/token' \
  --header 'content-type: application/x-www-form-urlencoded' \
  --data grant_type=password \
  --data username=<user> \
  --data password=<password> \
  --data scope='openid profile' \
  --data 'client_id=httpbin' \
  --data client_secret=<secret>

curl -k -i -X GET https://10.0.0.2/httpbin/ip -H "Authorization: Bearer"