#!/bin/sh
# Container entrypoint: print report (goes to RouterOS log with logging=yes), stay alive.
sh /opt/pbr/report.sh
exec tail -f /dev/null
