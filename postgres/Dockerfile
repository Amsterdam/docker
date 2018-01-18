FROM postgres:9.6

RUN apt-get update \
	&& apt-get install -y postgresql-9.6-postgis-scripts openssh-client wget \
	&& rm -rf /var/lib/apt/lists/*

RUN echo 'max_wal_size = 2GB' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'shared_buffers = 2GB' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'work_mem = 200mb' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'maintenance_work_mem = 2GB' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'checkpoint_completion_target = 0.9' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'fsync = off' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'synchronous_commit = off' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'full_page_writes = off' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"

RUN mkdir ~/.ssh
RUN ssh-keyscan admin.datapunt.amsterdam.nl >> ~/.ssh/known_hosts

COPY *.sh /bin/
COPY *.sql /docker-entrypoint-initdb.d/
