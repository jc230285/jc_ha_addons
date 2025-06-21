#!/bin/bash
set -e

# Install Node.js (Flood requires Node.js >=16)
apk add --no-cache nodejs npm git

# Install Flood
cd /opt
if [ ! -d flood ]; then
  git clone https://github.com/jesec/flood.git
fi
cd flood
git checkout master
npm install --production
