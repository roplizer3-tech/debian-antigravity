#!/bin/bash
set -e

PORT="${PORT:-8080}"
TERMINAL_USER="${TERMINAL_USER:-admin}"
TERMINAL_PASS="${TERMINAL_PASS:-Antigravity2026!}"

mkdir -p /workspace /data /root/.gemini/antigravity-cli

# Unify and ensure all original paths point to persistent storage in /data
mkdir -p /data/conversations /data/brain /data/.gemini/antigravity /data/.gemini/antigravity-cli /data/.gemini/config

# Ensure /root/.gemini links to /data/.gemini
if [ ! -L "/root/.gemini" ]; then
    rm -rf /root/.gemini
    ln -sfn /data/.gemini /root/.gemini
fi

# Ensure unified conversations and brain paths
ln -sfn /data/conversations /data/.gemini/antigravity/conversations
ln -sfn /data/conversations /data/.gemini/antigravity-cli/conversations
ln -sfn /data/brain /data/.gemini/antigravity/brain
ln -sfn /data/brain /data/.gemini/antigravity-cli/brain

# Ensure shell history persistence
touch /data/.bash_history
ln -sfn /data/.bash_history /root/.bash_history
if ! grep -q "history -a" /root/.bashrc 2>/dev/null; then
    echo 'export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"' >> /root/.bashrc
fi

export HOME="/root"
export TERM="xterm-256color"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

cd /workspace

echo "=========================================================="
echo " Starting Debian Linux (Google Antigravity Environment)"
echo " Listening on Port: $PORT"
echo " Authentication: $TERMINAL_USER / (protected)"
echo " Workspace: /workspace"
echo " Persistent Antigravity Storage: /data"
echo "=========================================================="

# Auto-start remote-control service
/usr/local/bin/agy remote-control start || true

AUTH_ARGS=""
if [ -n "$TERMINAL_USER" ] && [ -n "$TERMINAL_PASS" ]; then
    AUTH_ARGS="-c ${TERMINAL_USER}:${TERMINAL_PASS}"
fi

exec /usr/local/bin/ttyd $AUTH_ARGS -p "$PORT" -W -t fontSize=14 bash --login
