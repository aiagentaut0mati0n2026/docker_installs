# Backing Up and Restoring

All application data lives under `~/docker/`. Back up those directories and any `.env` files.

## What to Back Up
| Application | Path |
|---|---|
| Nginx Proxy Manager | `~/docker/nginx-proxy-manager/data/` and `letsencrypt/` |
| Portainer CE | `~/docker/portainer/portainer_data/` |
| Navidrome | `~/docker/navidrome/data/` |
| Remotely | `~/docker/remotely/var/www/remotely/` and `pg_data/` |
| Guacamole | `~/docker/guacamole/guac_config/` |
| Uptime Kuma | `~/docker/uptime-kuma/data/` |
| RustDesk | `~/docker/rustdesk/hbbs/` (contains private key — treat as sensitive) |
| Beszel | `~/docker/beszel/beszel_data/` |

## Simple Backup
```bash
mkdir -p ~/backups
cd ~/docker/<appname>
sudo docker compose stop
tar -czf ~/backups/<appname>-$(date +%Y%m%d).tar.gz -C ~/docker <appname>
sudo docker compose start
```

## Backup All at Once
```bash
mkdir -p ~/backups
for dir in ~/docker/*/; do
    name=$(basename "$dir")
    (cd "$dir" && sudo docker compose stop)
    tar -czf ~/backups/${name}-$(date +%Y%m%d).tar.gz -C ~/docker "$name"
    (cd "$dir" && sudo docker compose start)
done
```

## PostgreSQL Dump (Remotely)
```bash
docker exec remotely-postgres pg_dump -U remotely_user Remotely > ~/backups/remotely-db-$(date +%Y%m%d).sql
```

## Restoring
1. `sudo docker compose down`
2. `rm -rf ~/docker/<appname>`
3. `tar -xzf ~/backups/<appname>-YYYYMMDD.tar.gz -C ~/docker/`
4. `sudo docker compose up -d`

## Scheduled Backup (cron)
```
0 2 * * * /bin/bash ~/backup-docker.sh >> ~/backups/backup.log 2>&1
```
