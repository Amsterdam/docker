FROM docker.elastic.co/elasticsearch/elasticsearch-oss:6.1.1
MAINTAINER datapunt@amsterdam.nl

COPY elasticsearch.yml /usr/share/elasticsearch/config/
COPY logging.yml /usr/share/elasticsearch/config/
COPY *.sh /bin/

# Allow graceful waiting for ports and easier editing
RUN yum install -y netcat vim
