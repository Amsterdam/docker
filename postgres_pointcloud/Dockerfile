FROM postgres:9.6
MAINTAINER datapunt.ois@amsterdam.nl

RUN apt-get update \
	&& apt-get install -y \
		postgresql-server-dev-9.6 \
		netcat \
		wget \
		git \
		cmake \
		build-essential \
		subversion \
		autoconf \
		libtool \
 	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# build GEOS
WORKDIR /temp
RUN git clone https://git.osgeo.org/gitea/geos/geos.git

WORKDIR /temp/geos
RUN git checkout 3.6.1

WORKDIR /temp/geos
RUN ./autogen.sh

WORKDIR /temp/geos
RUN ./configure

WORKDIR /temp/geos
RUN make -j 4

WORKDIR /temp/geos
RUN make install

RUN rm -rf /temp/geos

# Install recent GDAL
WORKDIR /temp
RUN git clone https://github.com/OSGeo/gdal.git

WORKDIR /temp/gdal
RUN git checkout tags/v2.1.3

WORKDIR /temp/gdal/gdal
RUN ./configure

WORKDIR /temp/gdal/gdal
RUN make -j 4

WORKDIR /temp/gdal/gdal
RUN make install

RUN rm -rf /temp/gdal

# build SFCGAL
RUN apt-get update \
	&& apt-get install -y \
		libproj-dev \
		libxml2-dev \
		libjson-c-dev \
		libcgal-dev \
		liblas-dev \
 	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /temp
RUN git clone https://github.com/Oslandia/SFCGAL.git

WORKDIR /temp/SFCGAL
RUN mkdir build

WORKDIR /temp/SFCGAL/build
RUN cmake ..

WORKDIR /temp/SFCGAL/build
RUN make -j 4

WORKDIR /temp/SFCGAL/build
RUN make install

RUN rm -rf /temp/SFCGAL

# build Postgis extensions
WORKDIR /temp
RUN wget http://download.osgeo.org/postgis/source/postgis-2.3.2.tar.gz
RUN tar -zxvf postgis-2.3.2.tar.gz

WORKDIR /temp/postgis-2.3.2
RUN ./configure

WORKDIR /temp/postgis-2.3.2
RUN make

WORKDIR /temp/postgis-2.3.2
RUN make install

RUN rm -rf /temp/postgis-2.3.2
RUN rm /temp/postgis-2.3.2.tar.gz

# build LAZPERF extensions
WORKDIR /temp
RUN git clone https://github.com/hobu/laz-perf.git

WORKDIR /temp/laz-perf
RUN mkdir build

WORKDIR /temp/laz-perf/build
RUN cmake ..

WORKDIR /temp/laz-perf/build
RUN make -j 4

WORKDIR /temp/laz-perf/build
RUN make install

RUN rm -rf /temp/laz-perf

# build Postgis pointcloud extension
WORKDIR /temp
RUN git clone https://github.com/pgpointcloud/pointcloud.git

WORKDIR /temp/pointcloud
RUN mkdir build

WORKDIR /temp/pointcloud/build
RUN cmake .. -DWITH_TESTS=FALSE

WORKDIR /temp/pointcloud/build
RUN make -j 4

WORKDIR /temp/pointcloud/build
RUN make install

RUN rm -rf /temp/pointcloud

# Prepare configuration
RUN ldconfig

RUN echo 'max_wal_size = 4GB' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'shared_buffers = 4GB' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'work_mem = 6GB' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'maintenance_work_mem = 3GB' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'checkpoint_completion_target = 0.9' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'fsync = off' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'full_page_writes = off' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"

COPY init-extensions.sql /docker-entrypoint-initdb.d/
