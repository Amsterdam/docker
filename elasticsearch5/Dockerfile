FROM elasticsearch:5
MAINTAINER datapunt@amsterdam.nl

COPY elasticsearch.yml /usr/share/elasticsearch/config/
COPY logging.yml /usr/share/elasticsearch/config/
COPY *.sh /bin/

# Allow graceful waiting for ports and easier editing
RUN apt-get update \
	&& apt-get install -y openssh-client wget netcat vim \
	&& rm -rf /var/lib/apt/lists/*

