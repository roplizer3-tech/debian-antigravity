#!/bin/bash
export HOME="/root"
export TERM="xterm-256color"
export USER="root"
export LOGNAME="root"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [ -f /run/use_native_chroot ]; then
    exec chroot /data/rootfs /bin/bash --login
else
    # PRoot provides complete user-space root virtualization with bind mounts
    exec proot -r /data/rootfs -0 \
        -b /dev \
        -b /proc \
        -b /sys \
        -b /workspace:/workspace \
        -b /data:/data \
        -b /etc/resolv.conf:/etc/resolv.conf \
        -w /root \
        /bin/bash --login
fi
