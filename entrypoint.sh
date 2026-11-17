#!/bin/bash
set -e

PORT="${PORT:-8080}"
TERMINAL_USER="${TERMINAL_USER:-admin}"
TERMINAL_PASS="${TERMINAL_PASS:-Antigravity2026!}"

mkdir -p /workspace /data /run /var/log/nginx /usr/share/portal

echo "=========================================================="
echo " Starting Debian 12 Workstation (VNC Desktop + Web Terminal)"
echo " Listening on Port: $PORT"
echo " User: $TERMINAL_USER"
echo " Storage: /data (Persistent SSD)"
echo " Workspace: /workspace"
echo "=========================================================="

# Check and initialize persistent rootfs
if [ ! -f "/data/rootfs/.persistent_root_ready" ]; then
    echo "[PERSISTENCE] First run detected. Initializing clean Debian rootfs in /data/rootfs..."
    mkdir -p /data/rootfs
    tar -cf - \
        --exclude=/proc \
        --exclude=/sys \
        --exclude=/dev \
        --exclude=/data \
        --exclude=/workspace \
        --exclude=/tmp \
        --exclude=/run \
        / | tar -xf - -C /data/rootfs/

    mkdir -p /data/rootfs/proc /data/rootfs/sys /data/rootfs/dev /data/rootfs/dev/pts /data/rootfs/tmp /data/rootfs/run /data/rootfs/data /data/rootfs/workspace
    chmod 1777 /data/rootfs/tmp

    # Policy to prevent service startup errors during apt-get install
    echo '#!/bin/sh' > /data/rootfs/usr/sbin/policy-rc.d
    echo 'exit 101' >> /data/rootfs/usr/sbin/policy-rc.d
    chmod +x /data/rootfs/usr/sbin/policy-rc.d

    # Factory reset script
    cat << 'EOF' > /data/rootfs/usr/local/bin/debian-reset
#!/bin/bash
echo "WARNING: This will wipe all system changes and reset Debian to clean factory state."
read -p "Type 'yes' to proceed: " confirm
if [ "$confirm" = "yes" ]; then
    rm -f /data/rootfs/.persistent_root_ready
    echo "Reset flag created. Restart the container on CranL to complete reset."
else
    echo "Aborted."
fi
EOF
    chmod +x /data/rootfs/usr/local/bin/debian-reset

    echo 'source /etc/profile' >> /data/rootfs/root/.bashrc

    touch /data/rootfs/.persistent_root_ready
    echo "[PERSISTENCE] Clean rootfs initialized successfully."
else
    echo "[PERSISTENCE] Existing persistent rootfs detected. All user changes preserved."
fi

# Synchronize welcome message and DNS
cp -f /etc/profile.d/welcome.sh /data/rootfs/etc/profile.d/welcome.sh 2>/dev/null || true
cp -L /etc/resolv.conf /data/rootfs/etc/resolv.conf 2>/dev/null || true

# Setup Nginx HTTP Basic Auth
htpasswd -bc /etc/nginx/.htpasswd "$TERMINAL_USER" "$TERMINAL_PASS"

# Setup Openbox menu & VNC startup files
mkdir -p /root/.vnc /root/.config/openbox
mkdir -p /data/rootfs/root/.vnc /data/rootfs/root/.config/openbox

cp -f /etc/xdg/openbox/menu.xml /root/.config/openbox/menu.xml 2>/dev/null || true
cp -f /etc/xdg/openbox/menu.xml /data/rootfs/root/.config/openbox/menu.xml 2>/dev/null || true

# Setup VNC password safely
VNC_SEC_ARGS="-SecurityTypes None"
if command -v vncpasswd >/dev/null 2>&1; then
    echo "$TERMINAL_PASS" | vncpasswd -f > /root/.vnc/passwd
    chmod 600 /root/.vnc/passwd
    cp -f /root/.vnc/passwd /data/rootfs/root/.vnc/passwd 2>/dev/null || true
    VNC_SEC_ARGS="-SecurityTypes VncAuth"
fi

# Setup xstartup
cp -f /etc/skel/.vnc/xstartup /root/.vnc/xstartup 2>/dev/null || true
chmod +x /root/.vnc/xstartup
cp -f /root/.vnc/xstartup /data/rootfs/root/.vnc/xstartup 2>/dev/null || true

# Clean stale X11 sockets/locks
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

# 1. Start TigerVNC server on display :1 (port 5901)
echo "[VNC] Starting TigerVNC server on :1..."
vncserver :1 -geometry 1366x768 -depth 24 -localhost no $VNC_SEC_ARGS

# 2. Start websockify (noVNC web client) on port 6080
echo "[NOVNC] Starting websockify bridge on port 6080..."
websockify --web /usr/share/novnc 6080 localhost:5901 > /var/log/websockify.log 2>&1 &

# 3. Start ttyd web terminal on port 7681 (base path /terminal)
echo "[TTYD] Starting web terminal on port 7681..."
ttyd -p 7681 -b /terminal -W -t fontSize=15 -t fontFamily="monospace" -t 'theme={"background": "#181824", "foreground": "#e0e0e0"}' /usr/local/bin/enter-debian > /var/log/ttyd.log 2>&1 &

# 4. Start Nginx reverse proxy on $PORT
echo "[NGINX] Starting frontend proxy on port $PORT..."
exec nginx -g "daemon off;"
