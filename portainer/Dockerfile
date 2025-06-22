ARG BUILD_FROM=ghcr.io/hassio-addons/base:17.2.5
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG BUILD_ARCH=amd64
ARG PORTAINER_VERSION=2.19.4
ENV XDG_CONFIG_HOME="/config/xdg"

# hadolint ignore=DL3003,DL3042
RUN \
  apk add --no-cache \
    curl=8.8.0-r1 \
    jq=1.7.1-r1 \
  \
  && if [ "${BUILD_ARCH}" = "aarch64" ]; then PORTAINER_ARCH="arm64"; \
  elif [ "${BUILD_ARCH}" = "amd64" ]; then PORTAINER_ARCH="amd64"; \
  elif [ "${BUILD_ARCH}" = "armv7" ]; then PORTAINER_ARCH="arm"; fi \
  \
  && curl -L -s \
      "https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-${PORTAINER_ARCH}.tar.gz" \
      | tar zxvf - -C /opt/ \
  && chmod +x /opt/portainer/portainer \
  \
  && echo -e "UpdateMethod=docker\nBranch=master\nPackageVersion=${BUILD_VERSION}\nPackageAuthor=Home Assistant Community Add-ons" \
    > /opt/package_info \
  \
  && rm -f -r \
    /tmp/*

# Copy root filesystem
COPY rootfs /

WORKDIR /opt/portainer

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

VOLUME /data
EXPOSE 9000

CMD ["/opt/portainer/portainer", "--data", "/data", "--no-analytics"]
