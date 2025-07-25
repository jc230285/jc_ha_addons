#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# Clean up on exit:
TTY0_DELETED="" #Need to set to empty string since runs with nounset=on (like set -u)
trap '[ -n "$(jobs -p)" ] && kill $(jobs -p); [ -n "$TTY0_DELETED" ] && mknod -m 620 /dev/tty0 c 4 0 && mount -o remount,ro /dev; exit' INT TERM EXIT
################################################################################
# Add-on: HAOS Kiosk Display (haoskiosk)
# File: run.sh
# Version: 0.9.8
# Copyright Jeff Kosowsky
# Date: June 2025
#
#  Code does the following:
#     - Import and sanity-check the following variables from HA/config.yaml
#         HA_USERNAME
#         HA_PASSWORD
#         HA_URL
#         HA_DASHBOARD
#         HA_THEME
#         HA_SIDEBAR
#         LOGIN_DELAY
#         ZOOM_LEVEL
#         BROWSER_REFRESH
#         SCREEN_TIMEOUT
#         HDMI_PORT
#     - Hack to delete (and later restore) /dev/tty0 (needed for X to start)
#     - Start X window system
#     - Start Openbox window manager
#     - Poll to check if monitor wakes up and if so, reload luakit browser
#     - Launch fresh Luakit browser for url: $HA_URL/$HA_DASHBOARD
#
################################################################################
bashio::log.info "Starting haoskiosk..."
### Get config variables from HA add-on & set environment variables
HA_USERNAME=$(bashio::config 'ha_username')
HA_USERNAME="${HA_USERNAME/null/}"

HA_PASSWORD=$(bashio::config 'ha_password')
HA_PASSWORD="${HA_PASSWORD/null/}"

HA_URL=$(bashio::config 'ha_url')
HA_URL="${HA_URL/null/}"

HA_DASHBOARD=$(bashio::config 'ha_dashboard')
HA_DASHBOARD="${HA_DASHBOARD/null/}"

HA_THEME=$(bashio::config 'ha_theme')
HA_THEME="${HA_THEME/null/}"

HA_SIDEBAR=$(bashio::config 'ha_sidebar')
HA_SIDEBAR="${HA_SIDEBAR/null/}"

LOGIN_DELAY=$(bashio::config 'login_delay')
LOGIN_DELAY="${LOGIN_DELAY/null/}"

ZOOM_LEVEL=$(bashio::config 'zoom_level')
ZOOM_LEVEL="${ZOOM_LEVEL/null/}"

BROWSER_REFRESH=$(bashio::config 'browser_refresh')
BROWSER_REFRESH="${BROWSER_REFRESH/null/}"

export HA_USERNAME HA_PASSWORD HA_URL HA_DASHBOARD HA_THEME HA_SIDEBAR LOGIN_DELAY ZOOM_LEVEL BROWSER_REFRESH #Referenced in 'userconfig.lua'

SCREEN_TIMEOUT=$(bashio::config 'screen_timeout')
SCREEN_TIMEOUT="${SCREEN_TIMEOUT/null/}"
SCREEN_TIMEOUT="${SCREEN_TIMEOUT:-600}" #Default to 600 seconds

HDMI_PORT=$(bashio::config 'hdmi_port')
HDMI_PORT="${HDMI_PORT/null/}"
HDMI_PORT="${HDMI_PORT:-0}"
#NOTE: For now, both HDMI ports are mirrored and there is only /dev/fb0
#      Not sure how to get them unmirrored so that console can be on /dev/fb0 and X on /dev/fb1
#      As a result, setting HDMI=0 vs. 1 has no effect

#Validate environment variables set by config.yaml
if [ -z "$HA_USERNAME" ] || [ -z "$HA_PASSWORD" ]; then
    bashio::log.error "Error: HA_USERNAME and HA_PASSWORD must be set"
    exit 1
fi

bashio::log.info "HA_USERNAME=$HA_USERNAME HA_PASSWORD=XXXXX HA_URL=$HA_URL HA_DASHBOARD=$HA_DASHBOARD HA_THEME=$HA_THEME HA_SIDEBAR=$HA_SIDEBAR"
bashio::log.info "LOGIN_DELAY=$LOGIN_DELAY ZOOM_LEVEL=$ZOOM_LEVEL BROWSER_REFRESH=$BROWSER_REFRESH SCREEN_TIMEOUT=$SCREEN_TIMEOUT HDMI_PORT=$HDMI_PORT"

################################################################################
### Avoid waiting for DBUS timeouts (e.g., luakit)
export DBUS_SESSION_BUS_ADDRESS=/dev/null

### Start Xorg in the background
rm -rf /tmp/.X*-lock #Cleanup old versions

#Note first need to delete /dev/tty0 since X won't start if it is there,
#because X doesn't have permissions to access it in the container
#First, remount /dev as read-write since X absolutely, must have /dev/tty access
#Note: need to use the version in util-linux, not busybox
if [ -e "/dev/tty0" ]; then
    bashio::log.info "Attempting to (temporarily) delete /dev/tty0..."
    mount -o remount,rw /dev
    if ! mount -o remount,rw /dev ; then
        bashio::log.error "Failed to remount /dev as read-write..."
        exit 1
    fi
    if  ! rm /dev/tty0 ; then
        mount -o remount,ro /dev
        bashio::log.error "Failed to delete /dev/tty0..."
        exit 1
    fi
    TTY0_DELETED=1
    bashio::log.info "Deleted /dev/tty0 successfully..."
fi

Xorg "$DISPLAY" -layout "Layout${HDMI_PORT}" </dev/null &

XSTARTUP=30
for ((i=0; i<=XSTARTUP; i++)); do
    if xset q >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

#Restore /dev/tty0 and 'ro' mode for /dev if deleted
if [ -n "$TTY0_DELETED" ]; then
    if ( mknod -m 620 /dev/tty0 c 4 0 &&  mount -o remount,ro /dev ); then
        bashio::log.info "Restored /dev/tty0 successfully..."
    else
        bashio::log.error "Failed to restore /dev/tty0 and remount /dev/ read only..."
    fi
fi

if ! xset q >/dev/null 2>&1; then
    bashio::log.error "Error: X server failed to start within $XSTARTUP seconds."
    exit 1
fi
bashio::log.info "X started successfully..."

# Wait for displays to be ready
sleep 2

# Check available displays
bashio::log.info "Available displays:"
xrandr | bashio::log.info

# Configure displays with xrandr to use BenQ monitor
bashio::log.info "Configuring displays..."
xrandr --output HDMI-A-1 --off 2>&1 | bashio::log.info || true
xrandr --output HDMI-A-2 --auto --primary 2>&1 | bashio::log.info || true
bashio::log.info "Configured display to use BenQ monitor on HDMI-A-2..."

#Stop console blinking cursor (this projects through the X-screen)
echo -e "\033[?25l" > /dev/console

### Start Openbox in the background
openbox &
O_PID=$!
sleep 0.5  #Ensure Openbox starts
if ! kill -0 "$O_PID" 2>/dev/null; then #Checks if process alive
    bashio::log.error "Failed to start Openbox window manager"
    exit 1
fi
bashio::log.info "Openbox started successfully..."

### Configure screen timeout (Note: DPMS needs to be enabled/disabled *after* starting Openbox)
if [ "$SCREEN_TIMEOUT" -eq 0 ]; then #Disable screen saver and DPMS for no timeout
    xset s 0
    xset dpms 0 0 0
    xset -dpms
    bashio::log.info "Screen timeout disabled..."
else
    xset s "$SCREEN_TIMEOUT"
    xset dpms "$SCREEN_TIMEOUT" "$SCREEN_TIMEOUT" "$SCREEN_TIMEOUT"  #DPMS standby, suspend, off
    xset +dpms
    bashio::log.info "Screen timeout after $SCREEN_TIMEOUT seconds..."
fi

# Poll to send <Control-r> when screen unblanks to force reload of luakit page
(
    PREV=""
    while true; do
        if pgrep luakit > /dev/null; then
            STATE=$(xset -q | awk '/Monitor is/ {print $3}')
            [[ "$PREV" == "Off" && "$STATE" == "On" ]] && xdotool key --clearmodifiers ctrl+r
            PREV=$STATE
        fi
        sleep 1
    done
)&

#luakit -U "$HA_URL/$HA_DASHBOARD" #DEBUG
#exec sleep 100000 #DEBUG
### Run Luakit in the foreground
bashio::log.info "Launching Luakit browser..."
exec luakit -U "$HA_URL/$HA_DASHBOARD"
