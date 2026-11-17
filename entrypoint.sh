#!/bin/bash
set -e

PORT="${PORT:-8080}"
TERMINAL_USER="${TERMINAL_USER:-admin}"
TERMINAL_PASS="${TERMINAL_PASS:-Antigravity2026!}"

mkdir -p /workspace /data /root/.gemini/antigravity-cli

export HOME="/root"
export TERM="xterm-256color"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

cd /workspace

echo "=========================================================="
echo " Starting Debian Linux (Google Antigravity Environment)"
echo " Listening on Port: $PORT"
echo " Authentication: $TERMINAL_USER / (protected)"
echo " Workspace: /workspace"
echo "=========================================================="

# Auto-start remote-control service
/usr/local/bin/agy remote-control start || true

AUTH_ARGS=""
if [ -n "$TERMINAL_USER" ] && [ -n "$TERMINAL_PASS" ]; then
    AUTH_ARGS="-c ${TERMINAL_USER}:${TERMINAL_PASS}"
fi

exec /usr/local/bin/ttyd $AUTH_ARGS -p "$PORT" -W -t fontSize=14 bash --login
