FROM ghcr.io/apache/flink-kubernetes-operator:1.3.1
ENV FLINK_PLUGINS_DIR=/opt/flink/plugins
ADD --chown=9999:9999 --chmod=0644 https://repo1.maven.org/maven2/org/apache/flink/flink-s3-fs-hadoop/1.15.4/flink-s3-fs-hadoop-1.15.4.jar $FLINK_PLUGINS_DIR/flink-s3-fs-hadoop/
ADD --chown=9999:9999 --chmod=0644 https://repo1.maven.org/maven2/org/apache/flink/flink-s3-fs-presto/1.15.4/flink-s3-fs-presto-1.15.4.jar $FLINK_PLUGINS_DIR/flink-s3-fs-presto/

# docker build . --tag=k8s-lb:5000/apache/flink-kubernetes-operator:1.3.1.1
# docker push k8s-lb:5000/apache/flink-kubernetes-operator:1.3.1.1
# sudo crictl rmi --prune