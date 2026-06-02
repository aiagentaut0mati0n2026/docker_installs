# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

---

## [2.0.0] - 2026-06

### Added
- Ubuntu 26.04 LTS (Resolute Raccoon) added to the OS selection menu as option 5.
- Beszel lightweight system monitoring hub added as an installable application.
- `set -euo pipefail` added to the install script.
- Health checks added to every Docker Compose service.
- `TZ` environment variable added to all compose files.
- Portainer CE now exposes HTTPS port `9443`.
- Docker socket mounts changed to read-only (`:ro`).
- Uptime Kuma image tag changed from deprecated `:latest` (frozen at v1) to `:2` (current stable v2).
- Guacamole conflicting named volume declaration removed.

### Fixed
- `pid=$` (missing `!`) in Raspbian spinner sections corrected to `pid=$!`.
- Beszel install section output messages corrected (previously printed "Uptime Kuma").
- `exit 1` at end of successful install replaced with `exit 0`.

---

## [1.0.0] - Initial release

### Added
- Interactive install script for Docker CE, Docker Compose, Nginx Proxy Manager, Portainer CE, Portainer Agent, Navidrome, Remotely, Guacamole, Uptime Kuma, and RustDesk Server.
- Support for CentOS 7/8/Fedora, Debian 10/11, Ubuntu 18.04/20.04/22.04, Arch Linux, OpenSUSE, and Raspbian/Arm64.
- Shared Docker network `my-main-net` created automatically during install.
- RustDesk ed25519 key pair generated automatically during install.
- Remotely PostgreSQL password generated randomly during install.
