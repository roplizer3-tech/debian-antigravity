# Debian GNU/Linux 12 (Bookworm) - Cloud Workstation (VNC Desktop + Web Terminal)

A modern, ultra-lightweight Debian 12 (Bookworm) cloud workstation that combines an **extremely smooth graphical desktop (Openbox + TigerVNC + noVNC)** and a **fast web terminal (ttyd)** on **ONE SINGLE WEB URL**.

## Key Features

- **Dual-Interface on a Single URL**: Seamlessly toggle between **Desktop (VNC)** and **Terminal** from a modern top navigation bar without reloading or losing state.
- **Ultra-Lightweight & Smooth**: Uses Openbox, TigerVNC, Tint2, and PCManFM for a responsive desktop experience that uses less than 100 MB RAM and adapts smoothly to any screen size.
- **100% Full-System Persistence**: Any packages installed via `apt`, configuration files modified in `/etc`, desktop icons, scripts, or user data are permanently preserved on the 171 GB persistent NVMe volume (`/data/rootfs`).
- **Unified Security & Password Protection**: Protected with HTTP Basic Authentication (`admin` / `Antigravity2026!`) as well as internal VNC authentication.

## Access

Navigate to your CranL app URL:
- **Username**: `admin`
- **Password**: `Antigravity2026!`

### Navigation:
- Click **Desktop (VNC)** for the smooth graphical GUI.
- Click **Terminal** for the web console.
- Click **Fullscreen** to enter immersive full-screen workstation mode.
