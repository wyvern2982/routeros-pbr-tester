#!/bin/sh
. /opt/pbr/pbr.conf

echo "=== PBR test $(date '+%F %T') ==="
echo "--- address"
ip -4 -o addr show scope global | awk '{print "  " $2 "  " $4}'
echo "  gateway: $(ip -4 route show default | awk '{print $3; exit}')"
echo "  public IPv4 (= WAN used): $(curl -4 -s --max-time 5 "$PUBLIC_IP_URL" || echo unreachable)"

echo "--- ping"
for t in $PING_TARGETS; do
    ping -c 4 -W 2 -q "$t" 2>&1 | awk -v t="$t" '
        /packet loss/ {loss=$0}
        /min\/avg\/max/ {split($0, a, "= "); rtt=a[2]}
        END {printf "  %-15s %s | rtt %s\n", t, loss, (rtt ? rtt : "-")}'
done

echo "--- traceroute $TRACE_TARGET"
if command -v mtr >/dev/null 2>&1; then
    mtr -4 -n -r -c 3 "$TRACE_TARGET"
else
    traceroute -n -w 2 "$TRACE_TARGET"
fi
