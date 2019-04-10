FROM python:3.7.2-stretch

MAINTAINER datapunt@amsterdam.nl

ENV PYTHONUNBUFFERED 1

COPY apt/stable.pref /etc/apt/preferences.d/
COPY apt/stable.list /etc/apt/preferences.d/

WORKDIR /app
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get autoremove -y

RUN apt-get install -y \
        sudo \
        unzip \
        wget \
        dnsutils \
        vim \
        net-tools \
        netcat \
        libgeos-dev \
        gdal-bin \
        libgdal20 \
        libspatialite7 \
        libfreexl1 \
        libgeotiff2 \
        proj-bin \
        lsb-release \
        ca-certificates \
 && pip install --upgrade pip \
 && pip install uwsgi

ENV PG_VERSION 11

# old libs are installed by default, remove them
RUN apt-get remove -y libpq-dev libpq5 && apt-get autoremove -y 
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main $PG_VERSION" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && apt-get upgrade -y && apt-get install -y pgdg-keyring 

RUN apt-get install -f -y postgresql-client-$PG_VERSION libpq5=11.2-1.pgdg90+1 postgresql-client-common=199.pgdg90+1
# incase of errors use aptitude aptitude --full-resolver postgresql-client-11 to find the correct packages


RUN mkdir /usr/local/share/ca-certificates/extras
COPY adp_rootca.crt /usr/local/share/ca-certificates/extras/
RUN chmod 644 /usr/local/share/ca-certificates/extras/adp_rootca.crt
RUN update-ca-certificates

RUN adduser --system datapunt
