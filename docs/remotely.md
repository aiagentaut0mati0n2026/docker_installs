# Remotely

Remotely is a web-based remote desktop and IT support tool for Windows and Linux.

## Port
| Port | Purpose |
|------|---------|
| 5000 | Web UI and agent relay |

Remotely requires HTTPS. Put it behind Nginx Proxy Manager.

## NPM Settings
| Setting | Value |
|---|---|
| Forward Hostname | remotely |
| Forward Port | 5000 |
| WebSocket Support | Yes |
| Force SSL | Yes |
| Custom header (Advanced tab) | `X-Forwarded-Proto https;` |

After setting up the proxy, log into Remotely > Settings and enable "Require HTTPS".

## Installing the Agent on Client Machines
1. Log into the Remotely web UI.
2. Go to Downloads.
3. Download and run the agent installer on the target machine.

## Troubleshooting
```bash
docker logs remotely
docker logs remotely-postgres
```

If the DB password in `.env` does not match `pg_data/`, stop the stack, delete `pg_data/`, and re-run `docker compose up -d`. This resets the database.
