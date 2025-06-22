#!/usr/bin/with-contenv bashio

# Start qBittorrent in the background
/init &

# Start Flood UI
cd /opt/flood || exit 1
node server/bin/www --port 3000 --rundir /config &

# Wait for background jobs
wait
