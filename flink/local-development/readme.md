wget https://github.com/apache/flink/archive/refs/tags/release-1.14.4.tar.gz && tar -xvf release-1.14.4.tar.gz && rm release-1.14.4.tar.gz

cd ./flinkDatastream/flink-release-1.14.4/flink-connectors/flink-connector-cassandra

mvn install

<skipTests>true</skipTests>
in pom.xml
under
<!--surefire for unit tests and integration tests-->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>2.22.2</version>
    <configuration>

