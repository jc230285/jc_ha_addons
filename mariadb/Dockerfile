ARG BUILD_FROM=ghcr.io/hassio-addons/base:17.2.5
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG BUILD_ARCH=amd64
ENV LANG C.UTF-8

# hadolint ignore=DL3003,DL3042
RUN \
  apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-server-utils \
    rsync \
    socat \
    galera \
    mysql-client \
  && mkdir -p /var/lib/mysql \
  && chown -R mysql:mysql /var/lib/mysql \
  && mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Copy configuration and scripts
COPY run.sh /run.sh
COPY rootfs /
RUN chmod a+x /run.sh

# Build arguments
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="James Criswell <james@crswll.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="James Criswell Add-ons" \
    org.opencontainers.image.authors="James Criswell <james@crswll.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/jc21/ha_addons" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

EXPOSE 3306
