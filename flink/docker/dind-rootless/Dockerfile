FROM docker:23.0.1-dind-rootless

USER root

RUN apk update \
    && apk add --no-cache socat

RUN addgroup -S --gid 9999 flink \
    && adduser -S --uid 9999 flink -G flink \
    && addgroup flink tty

RUN sed -i 's/rootless/flink/g' /etc/subuid \
    && sed -i 's/rootless/flink/g' /etc/subgid

COPY post-dockerd-entrypoint.sh /usr/local/bin/post-dockerd-entrypoint.sh
RUN chmod +x /usr/local/bin/post-dockerd-entrypoint.sh \
    && chown flink:flink /usr/local/bin/post-dockerd-entrypoint.sh

USER flink

ENTRYPOINT ["post-dockerd-entrypoint.sh"]

# docker pull docker:23.0.1-dind-rootless
# docker build . --no-cache --progress=plain --tag=k8s-lb:5000/docker:23.0.1.1-dind-rootless
# docker push k8s-lb:5000/docker:23.0.1.1-dind-rootless
# sudo crictl rmi --prune