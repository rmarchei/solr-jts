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

# install JTS library
RUN curl -sLo /tmp/jts-$JTS_VER.zip http://sourceforge.net/projects/jts-topo-suite/files/jts/$JTS_VER/jts-$JTS_VER.zip/download && \
  unzip -q -j -n /tmp/jts-$JTS_VER.zip lib/jts-$JTS_VER.jar -d /opt/solr/server/lib/ext/ && \
  md5sum /opt/solr/server/lib/ext/jts-$JTS_VER.jar | grep -q $JTS_MD5 && \
  rm -f /tmp/jts-$JTS_VER.zip && \
  chown -R $SOLR_USER. /opt/solr

ENTRYPOINT ["/opt/solr/bin/solr", "start", "-f"]
CMD ["-m", "512m"]
