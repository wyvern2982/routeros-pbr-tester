#!/bin/sh
# Interactive dashboard: run inside `/container shell <n>` as `sh /opt/pbr/menu.sh`.
pause() { printf '\n(any key) '; read -rsn1 _; }
while :; do
    clear
    sh /opt/pbr/report.sh
    printf '\n[r] refresh  [s] speed test  [t] live trace  [q] quit > '
    read -rsn1 k
    echo
    case "$k" in
        s) sh /opt/pbr/speed.sh; pause ;;
        t) . /opt/pbr/pbr.conf; mtr -4 -n "$TRACE_TARGET" ;;
        q) exit 0 ;;
    esac
done
