ARG BUILD_FROM=ghcr.io/hassio-addons/base:17.2.5
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG BUILD_ARCH=amd64
ARG BUILD_VERSION=dev
ARG N8N_VERSION=1.70.0
ENV NODE_ENV=production
ENV N8N_USER_FOLDER="/data"
ENV N8N_CONFIG_FILES="/data"

# hadolint ignore=DL3003,DL3042
RUN \
  apk add --no-cache \
    curl \
    jq \
    nodejs \
    npm \
    python3 \
    make \
    g++ \
    git \
  \
  && npm install -g n8n@${N8N_VERSION} \
  && which n8n \
  && n8n --version \
  \
  && echo -e "UpdateMethod=docker\nBranch=master\nPackageVersion=${BUILD_VERSION}\nPackageAuthor=James Criswell Add-ons" \
    > /opt/package_info \
  \
  && rm -f -r \
    /tmp/* \
    /root/.npm

# Create directories
RUN mkdir -p \
    /data

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
