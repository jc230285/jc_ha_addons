#!/bin/bash
# Start qBittorrent in the background
/init &

# Start Flood UI
cd /opt/flood
node server/bin/www --port 3000 --rundir /config &

# Wait for background jobs
wait
