FROM apache/flink:1.15.4

RUN apt-get update && \
  apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

RUN mkdir -m 0755 -p /etc/apt/keyrings && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update && \
  apt-get install docker-ce-cli -y

COPY docker ./bin/docker
RUN chmod 755 ./bin/docker && \
  chown flink:flink ./bin/docker

# docker pull apache/flink:1.15.4
# docker build . --no-cache --progress=plain --tag=k8s-lb:5000/apache/flink:1.15.4.1
# docker push k8s-lb:5000/apache/flink:1.15.4.1
# sudo crictl rmi --prune
# DOCKER_HOST=unix:///opt/flink/.docker/run/docker.sock docker ps