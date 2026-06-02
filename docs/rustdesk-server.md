# RustDesk Server

Self-hosted relay and signaling backend for the RustDesk remote desktop client.

## Services
| Container | Purpose |
|---|---|
| hbbs | ID/rendezvous server |
| hbbr | Relay server |

Both containers must run together.

## Ports (all must be open in your firewall)
| Port | Protocol | Purpose |
|---|---|---|
| 21115 | TCP | NAT type test |
| 21116 | TCP | Hole punching and ID registration |
| 21116 | UDP | Heartbeat |
| 21117 | TCP | Relay traffic |
| 21118 | TCP | WebSocket for web clients |
| 21119 | TCP | WebSocket relay |

```bash
sudo ufw allow 21115/tcp && sudo ufw allow 21116/tcp && sudo ufw allow 21116/udp
sudo ufw allow 21117/tcp && sudo ufw allow 21118/tcp && sudo ufw allow 21119/tcp
```

RustDesk does NOT go behind Nginx Proxy Manager.

## Key Pair
The install script generates the key pair automatically. To view it later:
```bash
cat ~/docker/rustdesk/hbbs/id_ed25519.pub
```
Back up both `id_ed25519` and `id_ed25519.pub`.

## Configuring Clients
Settings > Network: set ID Server, Relay Server to your FQDN, and Key to the pub key content.
