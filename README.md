# Docker Installs

A single interactive bash script that installs Docker CE, the Docker Compose plugin, and a collection of self-hosted Docker applications on any supported Linux system. Answer a few yes/no prompts and the script handles everything else.

---

## Supported Operating Systems

| # | OS |
|---|---|
| 1 | CentOS 7 / 8 / Fedora |
| 2 | Debian 10 / 11 / 12 |
| 3 | Ubuntu 18.04 |
| 4 | Ubuntu 20.04 / 21.04 / 22.04 / 24.04 |
| 5 | Ubuntu 26.04 LTS (Resolute Raccoon) |
| 6 | Arch Linux |
| 7 | OpenSUSE |
| 8 | Arm64 / Raspbian |

---

## Quick Start

```bash
wget -O install-docker.sh https://raw.githubusercontent.com/aiagentaut0mati0n2026/docker_installs/main/install_docker_nproxyman.sh
chmod +x install-docker.sh
./install-docker.sh
```

---

## Supported Applications

| Application | Description | Default Port |
|---|---|---|
| Nginx Proxy Manager | Reverse proxy with web UI and automatic SSL | 80, 81, 443 |
| Portainer CE | Docker management web UI | 9000, 9443 |
| Portainer Agent | Remote agent for a Portainer CE instance | 9001 |
| Navidrome | Self-hosted music streaming server | 4533 |
| Remotely | Web-based remote desktop and support tool | 5000 |
| Guacamole | Browser-based remote desktop gateway (RDP/SSH/VNC) | 8080 |
| Uptime Kuma | Uptime monitoring with notifications | 3001 |
| RustDesk Server | Self-hosted remote desktop relay server | 21115-21119 |
| Beszel | Lightweight system monitoring hub | 8090 |

---

## Documentation

Detailed guides for each application are in the [docs/](docs/) folder:

- [Nginx Proxy Manager](docs/nginx-proxy-manager.md)
- [Portainer CE](docs/portainer-ce.md)
- [Portainer Agent](docs/portainer-agent.md)
- [Navidrome](docs/navidrome.md)
- [Remotely](docs/remotely.md)
- [Guacamole](docs/guacamole.md)
- [Uptime Kuma](docs/uptime-kuma.md)
- [RustDesk Server](docs/rustdesk-server.md)
- [Beszel](docs/beszel.md)
- [Updating Containers](docs/updating-containers.md)
- [Backing Up and Restoring](docs/backup-restore.md)
- [Troubleshooting](docs/troubleshooting.md)

---

## License

This project is offered free of charge and without warranty. See [LICENSE](LICENSE) for the full text.
