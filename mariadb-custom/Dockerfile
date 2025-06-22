FROM ghcr.io/home-assistant/amd64-base-debian:bookworm

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -y mariadb-server galera-4 rsync socat && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
COPY galera.cnf /etc/mysql/mariadb.conf.d/60-galera.cnf
COPY rootfs/ / # Add s6 service directory

RUN chmod a+x /run.sh

# s6-overlay will handle service startup
