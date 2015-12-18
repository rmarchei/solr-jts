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

FROM rmarchei/solr:latest
MAINTAINER Ruggero Marchei <ruggero.marchei@daemonzone.net>

# install JTS library 1.13
RUN curl -sLo /tmp/jts-1.13.zip http://sourceforge.net/projects/jts-topo-suite/files/jts/1.13/jts-1.13.zip/download && \
  unzip -q -j -n /tmp/jts-1.13.zip lib/jts-1.13.jar -d /opt/solr/server/lib/ext/ && \
  md5sum /opt/solr/server/lib/ext/jts-1.13.jar | grep -q b5546b98b6373f796d093217f3f73b66 && \
  rm -f /tmp/jts-1.13.zip && \
  chown -R $SOLR_USER. /opt/solr

ENTRYPOINT ["/opt/solr/bin/solr", "start", "-f"]
CMD ["-m", "512m"]
