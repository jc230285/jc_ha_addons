ARG BUILD_FROM
FROM $BUILD_FROM

# Install dependencies for qBittorrent and Flood UI if needed
# RUN apk add --no-cache nodejs npm

COPY install_flood.sh /install_flood.sh
RUN chmod +x /install_flood.sh && /install_flood.sh

COPY rootfs/ /

# s6-overlay will handle service startup
