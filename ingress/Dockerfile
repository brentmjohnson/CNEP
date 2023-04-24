FROM apache/apisix-dashboard:2.13-alpine
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
ADD ./cluster/etcd/ca.crt /usr/local/share/ca-certificates/ca.crt
RUN chmod 644 /usr/local/share/ca-certificates/ca.crt 
RUN update-ca-certificates