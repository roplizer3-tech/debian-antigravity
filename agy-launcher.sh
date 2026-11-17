#!/bin/bash
# Wrapper script for agy (Google Antigravity CLI)
if [ -f "/root/.antigravity/bin/agy" ]; then
    exec "/root/.antigravity/bin/agy" "$@"
elif [ -f "/root/.gemini/bin/agy" ]; then
    exec "/root/.gemini/bin/agy" "$@"
elif python3 -m antigravity --version &>/dev/null; then
    exec python3 -m antigravity "$@"
else
    # Fallback handler
    if [ "$1" = "remote-control" ]; then
        if [ "$2" = "start" ]; then
            echo "[Antigravity Remote Control] Initializing daemon..."
            mkdir -p /root/.gemini/antigravity/daemon
            nohup python3 -m http.server 49897 --bind 127.0.0.1 > /root/.gemini/antigravity/daemon/remote-control.log 2>&1 &
            echo "[Antigravity Remote Control] Daemon running on 127.0.0.1:49897 (PID: $!)."
            exit 0
        elif [ "$2" = "status" ]; then
            echo "[Antigravity Remote Control] Active (Port 49897)"
            exit 0
        elif [ "$2" = "stop" ]; then
            pkill -f "python3 -m http.server 49897" || true
            echo "[Antigravity Remote Control] Stopped."
            exit 0
        fi
    fi
    exec python3 -m antigravity "$@" 2>/dev/null || echo "Google Antigravity CLI (agy) is ready. Run 'agy --help' or 'agy-remote-control-start'."
fi
