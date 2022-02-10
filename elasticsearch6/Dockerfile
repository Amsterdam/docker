FROM docker.elastic.co/elasticsearch/elasticsearch-oss:6.8.12
MAINTAINER datapunt@amsterdam.nl

# Allow graceful waiting for ports and easier editing
RUN yum install -y netcat vim
RUN yum install -y openssh-clients

COPY elasticsearch.yml /usr/share/elasticsearch/config/

# For version 6.8.12 of the elasticsearch-oss image, 
# we need to explictly add the following setting
# to avoid the Log4J vulnerability.
RUN echo '-Dlog4j2.formatMsgNoLookups=true' >> /usr/share/elasticsearch/config/jvm.options

COPY logging.yml /usr/share/elasticsearch/config/
COPY *.sh /bin/
