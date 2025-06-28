ARG BUILD_FROM=ghcr.io/hassio-addons/base:17.2.5
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG BUILD_ARCH=amd64
ARG BUILD_VERSION=dev
ENV NODE_ENV=production

# Install n8n directly from the official Docker image
RUN \
  apk add --no-cache \
    curl \
    jq \
    nodejs \
    npm \
  \
  && npm install -g n8n@1.70.0 --unsafe-perm \
  && npm cache clean --force \
  && npm cache clean --force \
  \
  && echo -e "UpdateMethod=docker\nBranch=master\nPackageVersion=${BUILD_VERSION}\nPackageAuthor=James Criswell Add-ons" \
    > /opt/package_info \
  \
  && rm -f -r \
    /tmp/* \
    /root/.npm

# Set n8n environment variables
ENV N8N_USER_FOLDER="/data"
ENV N8N_CONFIG_FILES="/data"
ENV N8N_HOST="0.0.0.0"
ENV N8N_PORT="5678"

# Create directories
RUN mkdir -p /data

# Copy root filesystem
COPY rootfs /

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

# Volumes
VOLUME ["/data"]

# Expose ports
EXPOSE 5678
