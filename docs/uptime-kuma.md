# Uptime Kuma

Uptime Kuma monitors HTTP(S), TCP, DNS, Docker containers, and more with 90+ notification channels.

## Image Tag Note
This stack uses `:2`, not `:latest`. The `:latest` tag is permanently frozen at v1 and is officially deprecated.

## Port
| Port | Purpose |
|------|---------|
| 3001 | Web UI |

Do not store data on NFS — Uptime Kuma uses SQLite and requires POSIX file locking.

## NPM Settings
| Setting | Value |
|---|---|
| Forward Hostname | uptime-kuma |
| Forward Port | 3001 |
| WebSocket Support | Yes (required for live dashboard) |
| Force SSL | Yes |

## Updating
```bash
cd ~/docker/uptime-kuma
sudo docker compose pull && sudo docker compose up -d
```

If upgrading from v1 to v2, read the migration guide first:
https://github.com/louislam/uptime-kuma/wiki/Migration-From-V1-To-V2
