#!/bin/sh
# Rough speed test via Cloudflare. Streams data; nothing is buffered in RAM.
. /opt/pbr/pbr.conf
mbit() { awk '{printf "%.1f Mbit/s\n", $1 * 8 / 1000000}'; }

printf "Download %s MB: " "$SPEED_DOWN_MB"
curl -4 -s -o /dev/null --max-time 60 -w '%{speed_download}\n' \
    "https://speed.cloudflare.com/__down?bytes=$((SPEED_DOWN_MB * 1000000))" | mbit

printf "Upload   %s MB: " "$SPEED_UP_MB"
head -c $((SPEED_UP_MB * 1000000)) /dev/zero |
    curl -4 -s -o /dev/null --max-time 60 -X POST -T - -w '%{speed_upload}\n' \
        https://speed.cloudflare.com/__up | mbit
