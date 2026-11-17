# Debian Linux Cloud Environment with Google Antigravity CLI

A full Debian 12 (Bookworm) container environment configured for AI development with:
- **Web Terminal**: Instant browser-based terminal powered by `ttyd` on port 8080.
- **Google Antigravity CLI**: Official `agy` CLI and SDK integration.
- **Remote Control Daemon**: Auto-started daemon for remote browser control.
- **systemd Compatibility**: Full `systemctl` support using `docker-systemctl-replacement`.
- **Persistence**: Workspaces in `/workspace`, persistent data in `/data`.

## Quick Start

### 1. Access the Web Terminal
Navigate to your app URL in the browser.
- Default User: `admin`
- Default Password: `Antigravity2026!`

### 2. Antigravity CLI & Remote Control
Run in the terminal:
```bash
agy
```
Or start/manage remote control:
```bash
agy-remote-control-start
systemctl status agy-remote-control
```
