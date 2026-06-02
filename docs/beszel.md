# Beszel

Lightweight system monitoring hub tracking CPU, memory, disk, and network across multiple hosts.

## Port
| Port | Purpose |
|------|---------|
| 8090 | Web UI |

## NPM Settings
| Setting | Value |
|---|---|
| Forward Hostname | beszel |
| Forward Port | 8090 |
| WebSocket Support | Yes |
| Force SSL | Yes |

## Monitoring the Host Machine
The compose file includes `host.docker.internal:host-gateway` so Beszel can reach host metrics without host networking. Use `host.docker.internal` as the address when adding the host machine in the Beszel UI.

## Adding Remote Hosts
1. Log into Beszel > Add System.
2. Beszel displays a Docker run command for the agent.
3. Run it on the remote machine.

The agent communicates back over SSH — no inbound ports needed on remote hosts.

## Updating
```bash
cd ~/docker/beszel
sudo docker compose pull && sudo docker compose up -d
```
