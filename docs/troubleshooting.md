# Troubleshooting

## General Docker Commands
```bash
docker ps                                    # Running containers
docker ps -a                                 # All containers
docker logs <container-name>                 # View logs
docker logs <container-name> --tail 50 -f   # Follow logs
cd ~/docker/<appname> && sudo docker compose restart
cd ~/docker/<appname> && sudo docker compose down && sudo docker compose up -d
```

## Container Will Not Start
```bash
sudo ss -tlnp | grep <port>          # Port already in use?
ls -la ~/docker/<appname>/           # Volume permissions?
cat ~/docker/<appname>/.env          # Missing env variable?
```

## Port Conflicts
Change the host-side port in the compose file:
```yaml
ports:
  - "3002:3001"   # left = host port, right = container port (do not change)
```

## Cannot Reach Web UI
1. `docker ps | grep <container-name>` — is it running?
2. `sudo ss -tlnp | grep <port>` — is it listening?
3. `sudo ufw status` — is the firewall blocking it?

## SSL Certificate Fails (NPM)
- Port 80 must be open from the internet.
- DNS A record must point to this server's public IP.
- Test: `curl -I http://yourdomain.com`

## WebSocket Errors (Uptime Kuma, Guacamole, Remotely)
In NPM: edit the proxy host > Details tab > enable WebSocket Support.

## Docker Network Issues
```bash
docker network inspect my-main-net
```
If a container is missing, confirm its compose file has:
```yaml
networks:
  default:
    name: my-main-net
    external: true
```

## Remotely: Database Connection Error
If pg_data/ was created with different credentials:
```bash
cd ~/docker/remotely
sudo docker compose down
rm -rf pg_data/
sudo docker compose up -d
```

## RustDesk: Clients Cannot Connect
1. All 6 ports open on host firewall and upstream firewall.
2. FQDN resolves to server public IP.
3. Key in client matches `cat ~/docker/rustdesk/hbbs/id_ed25519.pub`
```bash
docker logs hbbs && docker logs hbbr
sudo ss -tlnp | grep -E '21115|21116|21117'
```

## Check Install Log
```bash
cat ~/docker-script-install.log
```
