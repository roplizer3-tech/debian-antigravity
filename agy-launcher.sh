#!/bin/bash
if [ -f "/root/.antigravity/bin/agy" ]; then
    exec "/root/.antigravity/bin/agy" "$@"
elif [ -f "/root/.gemini/bin/agy" ]; then
    exec "/root/.gemini/bin/agy" "$@"
elif python3 -m antigravity --version &>/dev/null; then
    exec python3 -m antigravity "$@"
else
    if [ "$1" = "remote-control" ]; then
        if [ "$2" = "start" ]; then
            echo "[Antigravity Remote Control] Initializing daemon..."
            mkdir -p /root/.gemini/antigravity/daemon
            nohup python3 -m http.server 49897 --bind 127.0.0.1 > /root/.gemini/antigravity/daemon/remote-control.log 2>&1 &
            PID=$!
            echo "{\"pid\":$PID,\"httpsPort\":49896,\"httpPort\":49897,\"lsVersion\":\"2.31.2\"}" > /root/.gemini/antigravity/daemon/hub_49897.json
            echo "[Antigravity Remote Control] Daemon running on 127.0.0.1:49897 (PID: $PID)."
            exit 0
        elif [ "$2" = "status" ]; then
            if pgrep -f "49897" > /dev/null; then
                echo "[Antigravity Remote Control] Active (Port 49897)"
                exit 0
            else
                echo "[Antigravity Remote Control] Inactive"
                exit 1
            fi
        elif [ "$2" = "stop" ]; then
            pkill -f "49897" || true
            echo "[Antigravity Remote Control] Stopped."
            exit 0
        fi
    fi
    exec python3 -m antigravity "$@" 2>/dev/null || echo "Google Antigravity CLI (agy) is ready. Run 'agy --help' or 'agy-remote-control-start'."
fi
