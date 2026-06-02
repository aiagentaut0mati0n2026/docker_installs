# Updating Containers

All containers use `restart: unless-stopped`. Updating requires a manual pull and recreate.

## Updating a Single Application
```bash
cd ~/docker/<appname>
sudo docker compose pull
sudo docker compose up -d
```

## Updating All Applications at Once
```bash
for dir in ~/docker/*/; do
    if [ -f "$dir/docker-compose.yml" ]; then
        echo "Updating $(basename $dir)..."
        (cd "$dir" && sudo docker compose pull && sudo docker compose up -d)
    fi
done
```

## Removing Old Images
```bash
docker image prune -f
```

## Pinning to a Specific Version
Edit the `image:` line in the compose file:
```yaml
# Instead of:
image: louislam/uptime-kuma:2
# Pin to a specific release:
image: louislam/uptime-kuma:2.3.0
```
