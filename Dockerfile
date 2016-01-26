# Apache Solr - http://lucene.apache.org/solr/
# JTS Topology Suite - http://sourceforge.net/projects/jts-topo-suite/
#
# docker run -d \
#      --restart on-failure \
#      -p 8983:8983 \
#      --name solr \
#      rmarchei/solr-jts \
#      -m 8g
#

FROM rmarchei/solr:5.4.1
MAINTAINER Ruggero Marchei <ruggero.marchei@daemonzone.net>

env JTS_VER 1.14
env JTS_MD5 34bf317e5a270b91824a4548b88d3656

env MYSQL_CONNECTOR 5.1.38
env MYSQL_CONNECTOR_MD5 8f8e768a91338328f2ac5cd6b6683c88

# install JTS and MYSQL libraries
RUN curl -sLo /tmp/jts-$JTS_VER.zip http://sourceforge.net/projects/jts-topo-suite/files/jts/$JTS_VER/jts-$JTS_VER.zip/download && \
  unzip -q -j -n /tmp/jts-$JTS_VER.zip lib/jts-$JTS_VER.jar -d /opt/solr/server/lib/ext/ && \
  md5sum /opt/solr/server/lib/ext/jts-$JTS_VER.jar | grep -q $JTS_MD5 && \
  rm -f /tmp/jts-$JTS_VER.zip && \
  curl -sLo /tmp/mysql-connector-java-$MYSQL_CONNECTOR.tar.gz http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_CONNECTOR.tar.gz && \
  md5sum /tmp/mysql-connector-java-$MYSQL_CONNECTOR.tar.gz | grep -q $MYSQL_CONNECTOR_MD5 && \
  tar -C /opt/solr/server/lib/ext --extract --strip-components=1 --file /tmp/mysql-connector-java-$MYSQL_CONNECTOR.tar.gz mysql-connector-java-$MYSQL_CONNECTOR/mysql-connector-java-$MYSQL_CONNECTOR-bin.jar && \
  rm -f /tmp/mysql-connector-java-$MYSQL_CONNECTOR.tar.gz && \
  chown -R $SOLR_USER. /opt/solr

ENTRYPOINT ["/opt/solr/bin/solr", "start", "-f"]
CMD ["-m", "512m"]
