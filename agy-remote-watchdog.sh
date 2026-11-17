#!/bin/bash
while true; do
    if ! pgrep -f "remote-control serve" > /dev/null; then
        echo "[Watchdog] $(date): remote-control daemon not running, starting..." >> /data/remote-control-watchdog.log
        /root/.local/bin/agy remote-control start >> /data/remote-control-watchdog.log 2>&1 || true
    fi
    sleep 5
done
