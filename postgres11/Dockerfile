FROM postgres:11

RUN apt-get update \
	&& apt-get install -y postgresql-11-postgis-2.5-scripts openssh-client wget \
	&& rm -rf /var/lib/apt/lists/*

RUN echo 'max_wal_size = 2GB' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'shared_buffers = 2GB' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'work_mem = 200MB' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'maintenance_work_mem = 2GB' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'checkpoint_completion_target = 0.9' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'fsync = off' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'synchronous_commit = off' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'full_page_writes = off' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo 'ssl = on' >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo "ssl_cert_file = '/etc/ssl/certs/ssl-cert-snakeoil.pem'" >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"
RUN echo "ssl_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key'" >> "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"

RUN mkdir ~/.ssh
RUN ssh-keyscan admin.data.amsterdam.nl >> ~/.ssh/known_hosts

COPY *.sh /bin/
COPY *.sql /docker-entrypoint-initdb.d/
