ARG BUILD_FROM
FROM $BUILD_FROM

# Setup base
RUN apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-server-utils \
    mariadb-connector-c \
    galera \
    socat \
    rsync \
    pwgen

ENV \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"

# Copy data
COPY rootfs /

# Set executable permissions for custom scripts
RUN chmod +x /usr/bin/galera-debug \
    && chmod +x /usr/bin/galera-bootstrap \
    && chmod +x /usr/bin/lock-tables-for-backup \
    && chmod +x /usr/bin/unlock-tables-for-backup

WORKDIR /
