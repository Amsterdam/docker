FROM python:3.6.2-stretch

MAINTAINER datapunt.ois@amsterdam.nl

ENV PYTHONUNBUFFERED 1

COPY apt/stable.pref /etc/apt/preferences.d/
COPY apt/stable.list /etc/apt/sources.list.d/

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

RUN adduser --system datapunt

RUN uwsgi --build-plugin https://github.com/unbit/uwsgi-consul
