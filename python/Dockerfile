FROM python:3.7.2-stretch

MAINTAINER datapunt@amsterdam.nl

ENV PYTHONUNBUFFERED 1 \
    PIP_NO_CACHE_DIR=off

COPY apt/stable.pref /etc/apt/preferences.d/
COPY apt/stable.list /etc/apt/preferences.d/

WORKDIR /app
RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get autoremove -y \
 && apt-get install -y \
        sudo \
        unzip \
        wget \
        dnsutils \
        vim \
        net-tools \
        netcat \
        libgeos-dev \
        gdal-bin \
        postgresql-client-9.6 \
        libgdal20 \
        libspatialite7 \
        libfreexl1 \
        libgeotiff2 \
        proj-bin \
 && rm -rf /var/lib/apt/lists/* /var/cache/debconf/*-old \
 && pip install --upgrade pip \
 && pip install uwsgi \
 && mkdir /usr/local/share/ca-certificates/extras

COPY adp_rootca.crt /usr/local/share/ca-certificates/extras/
RUN chmod 644 /usr/local/share/ca-certificates/extras/adp_rootca.crt \
 && update-ca-certificates \
 && adduser --system datapunt
