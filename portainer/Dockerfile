ARG BUILD_FROM
FROM $BUILD_FROM

# Copy service scripts and entrypoints
COPY rootfs/ /

# Copy Portainer binary if needed (already in base image if using portainer/portainer-ce)

# Set permissions if needed
# RUN chmod a+x /run.sh

# s6-overlay will handle service startup
