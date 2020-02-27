FROM docker.elastic.co/elasticsearch/elasticsearch-oss:6.8.3
MAINTAINER datapunt@amsterdam.nl

# Allow graceful waiting for ports and easier editing
RUN yum install -y netcat vim
RUN yum install -y openssh-clients

COPY elasticsearch.yml /usr/share/elasticsearch/config/
COPY logging.yml /usr/share/elasticsearch/config/
COPY *.sh /bin/


