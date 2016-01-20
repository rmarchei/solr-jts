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

FROM rmarchei/solr:5.4.0-oracle
MAINTAINER Ruggero Marchei <ruggero.marchei@daemonzone.net>

env JTS_VER 1.13
env JTS_MD5 b5546b98b6373f796d093217f3f73b66

# install JTS library
RUN curl -sLo /tmp/jts-$JTS_VER.zip http://sourceforge.net/projects/jts-topo-suite/files/jts/$JTS_VER/jts-$JTS_VER.zip/download && \
  unzip -q -j -n /tmp/jts-$JTS_VER.zip lib/jts-$JTS_VER.jar -d /opt/solr/server/lib/ext/ && \
  md5sum /opt/solr/server/lib/ext/jts-$JTS_VER.jar | grep -q $JTS_MD5 && \
  rm -f /tmp/jts-$JTS_VER.zip && \
  chown -R $SOLR_USER. /opt/solr

ENTRYPOINT ["/opt/solr/bin/solr", "start", "-f"]
CMD ["-m", "512m"]
