# Debian GNU/Linux 12 (Bookworm) - Cloud Workstation (XFCE4 Desktop + Web Terminal)

A modern, high-performance Debian 12 (Bookworm) cloud workstation featuring a **full, clean graphical desktop (XFCE4 + TigerVNC + noVNC)** and a **web terminal (ttyd)** combined on **ONE SINGLE WEB URL**.

## Key Features

- **Full XFCE4 Graphical Desktop**: Includes Applications Menu, Desktop Icons (Home, Trash, File System), Taskbar with Window Buttons, Thunar File Manager, Mousepad Text Editor, and Xfce4-Terminal. Easily install and run any GUI or CLI applications.
- **Dual-Interface on a Single URL**: Switch seamlessly between **Desktop (XFCE GUI)** and **Terminal** from a top navigation bar.
- **Multi-Layer Password Protection**:
  - Web Login Gate: Beautiful web login form protecting the interface.
  - HTTP Basic Auth: Enforced at the Nginx reverse proxy level.
  - Terminal Security: Protected with credentials (`admin` / `Antigravity2026!`).
  - VNC Security: Encrypted VncAuth password protection.
- **100% Full-System Persistence**: Any packages installed via `apt`, desktop icons, settings, files, and configurations are permanently preserved on the 171 GB NVMe SSD volume (`/data/rootfs`).

## Access Credentials

- **Username**: `admin`
- **Password**: `Antigravity2026!`

Navigate to the CranL app URL, enter the credentials into the login gate to unlock both the XFCE Desktop and the Web Terminal.
