ARG BUILD_FROM
FROM $BUILD_FROM

# Install MariaDB with Galera from official repositories
RUN apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-server-utils \
    mariadb-connector-c \
    mariadb-backup \
    galera \
    socat \
    rsync \
    pwgen \
    netcat-openbsd

# Install Galera from source if needed for better port binding
RUN apk add --no-cache --virtual .build-deps \
    build-base \
    cmake \
    boost-dev \
    openssl-dev \
    && apk del .build-deps

ENV \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"

# Copy data
COPY rootfs /

# Set executable permissions for custom scripts
RUN chmod +x /usr/bin/galera-debug \
    && chmod +x /usr/bin/galera-bootstrap \
    && chmod +x /usr/bin/lock-tables-for-backup \
    && chmod +x /usr/bin/unlock-tables-for-backup \
    && chmod +x /etc/s6-overlay/s6-rc.d/*/run \
    && chmod +x /etc/s6-overlay/s6-rc.d/*/* \
    && chmod +x /etc/s6-overlay/s6-rc.d/*/*/*

WORKDIR /
