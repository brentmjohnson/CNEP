FROM apache/apisix:3.2.0-debian

USER root

COPY ./apisix/plugins/openid-connect.lua /usr/local/apisix/apisix/plugins/openid-connect.lua
RUN chmod 644 /usr/local/apisix/apisix/plugins/openid-connect.lua && \
    chown apisix:apisix /usr/local/apisix/apisix/plugins/openid-connect.lua

# RUN cat ./apisix/plugins/openid-connect.lua && \
#     ls -l ./apisix/plugins/

USER apisix

# docker pull "apache/apisix:3.2.0-debian"
# docker build . --no-cache --progress=plain --tag=k8s-lb:5000/apache/apisix:3.2.0.1-debian
# docker push k8s-lb:5000/apache/apisix:3.2.0.1-debian