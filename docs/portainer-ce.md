# Portainer CE

Portainer CE is a web-based management UI for Docker containers, images, volumes, networks, and stacks.

## Ports
| Port | Purpose |
|------|---------|
| 8000 | Edge Agent tunnel |
| 9000 | HTTP web UI |
| 9443 | HTTPS web UI (preferred) |

Do not expose these ports to the internet. Put Portainer behind Nginx Proxy Manager.

## First Login
Navigate to `http://<your-server-ip>:9000` or `https://<your-server-ip>:9443`.

Create your admin account on the first visit. You have 5 minutes before the setup page locks. If you miss it:
```bash
cd ~/docker/portainer && sudo docker compose restart
```

## NPM Settings
| Setting | Value |
|---|---|
| Scheme | https |
| Forward Hostname | portainer |
| Forward Port | 9443 |
| WebSocket Support | Yes |
| Force SSL | Yes |

## Security Notes
- The Docker socket mount gives root-equivalent access to the host.
- Enable two-factor authentication in Settings > My Account.

## Updating
```bash
cd ~/docker/portainer
sudo docker compose pull
sudo docker compose up -d
```
