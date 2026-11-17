# Debian GNU/Linux 12 (Bookworm) - 100% Persistent System

A clean, high-performance Debian 12 (Bookworm) container environment running on CranL Cloud with **100% Full-System Persistence**.

## Features

- **Pristine Base**: Clean Debian 12 Bookworm with essential development and networking tools (`curl`, `wget`, `git`, `htop`, `sudo`, `procps`, etc.).
- **100% Full-System Persistence**: Any packages installed via `apt`, configuration files modified in `/etc`, scripts in `/usr/local/bin` or files created in `/root` are permanently preserved on the 171 GB NVMe persistent volume (`/data/rootfs`).
- **Web Terminal**: Instant browser-based terminal powered by `ttyd` on port 8080.
- **Factory Reset**: If you ever want to revert back to a clean Debian installation, simply run `debian-reset` inside the terminal.

## Access

Navigate to the CranL app URL:
- **URL**: `https://debian-antigravity-i1hqyu.cranl.net`
- **Username**: `admin`
- **Password**: `Antigravity2026!`
