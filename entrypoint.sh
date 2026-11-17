#!/bin/bash
set -e

PORT="${PORT:-8080}"
TERMINAL_USER="${TERMINAL_USER:-admin}"
TERMINAL_PASS="${TERMINAL_PASS:-Antigravity2026!}"

mkdir -p /workspace /data /run

echo "=========================================================="
echo " Starting Debian Linux 12 (100% Persistent System)"
echo " Port: $PORT"
echo " Web Terminal Auth: $TERMINAL_USER / (protected)"
echo " Storage Volume: /data (Persistent SSD)"
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

    # Ensure profile sourcing
    echo 'source /etc/profile' >> /data/rootfs/root/.bashrc

    touch /data/rootfs/.persistent_root_ready
    echo "[PERSISTENCE] Clean Debian rootfs initialized successfully."
else
    echo "[PERSISTENCE] Existing persistent rootfs detected. All installed packages and files preserved."
fi

# Synchronize welcome message and DNS
cp -f /etc/profile.d/welcome.sh /data/rootfs/etc/profile.d/welcome.sh 2>/dev/null || true
cp -L /etc/resolv.conf /data/rootfs/etc/resolv.conf 2>/dev/null || true

# Test and enable native bind mounts if permitted by runtime
rm -f /run/use_native_chroot
if mount --bind /proc /data/rootfs/proc 2>/dev/null; then
    mount --bind /sys /data/rootfs/sys 2>/dev/null || true
    mount --bind /dev /data/rootfs/dev 2>/dev/null || true
    mount --bind /dev/pts /data/rootfs/dev/pts 2>/dev/null || true
    mount --bind /workspace /data/rootfs/workspace 2>/dev/null || true
    mount --bind /data /data/rootfs/data 2>/dev/null || true
    touch /run/use_native_chroot
    echo "[PERSISTENCE] Kernel native bind-mounts active. Mode: Native chroot."
else
    echo "[PERSISTENCE] Mode: PRoot full-system virtualization."
fi

AUTH_ARGS=""
if [ -n "$TERMINAL_USER" ] && [ -n "$TERMINAL_PASS" ]; then
    AUTH_ARGS="-c ${TERMINAL_USER}:${TERMINAL_PASS}"
fi

cd /workspace

exec /usr/local/bin/ttyd $AUTH_ARGS -p "$PORT" -W -t fontSize=15 -t fontFamily="monospace" -t 'theme={"background": "#181824", "foreground": "#e0e0e0"}' /usr/local/bin/enter-debian
