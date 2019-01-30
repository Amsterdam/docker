FROM python:3.6.7-stretch

MAINTAINER datapunt@amsterdam.nl

ENV PYTHONUNBUFFERED 1

COPY apt/stable.pref /etc/apt/preferences.d/
COPY apt/stable.list /etc/apt/preferences.d/

WORKDIR /app
RUN apt-get update \
&&  apt-get install -y \
        sudo \
        unzip \
        wget \
        dnsutils \
        vim \
        net-tools \
        netcat \
	postgresql-client-9.6 \
        libgeos-dev \
        gdal-bin \
        libgdal20 \
        libspatialite7 \
        libfreexl1 \
        libgeotiff2 \
        proj-bin \
 && pip install --upgrade pip \
 && pip install uwsgi

RUN mkdir /usr/local/share/ca-certificates/extras
COPY adp_rootca.crt /usr/local/share/ca-certificates/extras/
RUN chmod 644 /usr/local/share/ca-certificates/extras/adp_rootca.crt
RUN update-ca-certificates

RUN adduser --system datapunt

RUN uwsgi --build-plugin https://github.com/unbit/uwsgi-consul
