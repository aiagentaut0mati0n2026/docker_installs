# Nginx Proxy Manager

Nginx Proxy Manager gives you a web UI to manage reverse proxy rules, SSL certificates, access lists, and redirects.

## Ports
| Port | Purpose |
|------|---------|
| 80 | HTTP and Let's Encrypt HTTP-01 challenge |
| 81 | Admin web UI — restrict to LAN/VPN only |
| 443 | HTTPS public traffic |

## First Login
Navigate to `http://<your-server-ip>:81`

Default credentials:
```
Email:    admin@example.com
Password: changeme
```
Change both immediately after first login.

## Adding a Proxy Host
1. Log into NPM at port 81.
2. Go to Hosts > Proxy Hosts > Add Proxy Host.
3. Set Forward Hostname to the container name (e.g. `uptime-kuma`).
4. Enable WebSocket Support for Uptime Kuma, Remotely, and Guacamole.
5. On the SSL tab, request a Let's Encrypt certificate and enable Force SSL.

## Required Headers
**Remotely** — add in the Advanced tab:
```
X-Forwarded-Proto https;
```

## Updating
```bash
cd ~/docker/nginx-proxy-manager
sudo docker compose pull
sudo docker compose up -d
```

## Troubleshooting
```bash
docker logs nginx-proxy-manager
sudo ss -tlnp | grep -E ':80|:443|:81'
```
