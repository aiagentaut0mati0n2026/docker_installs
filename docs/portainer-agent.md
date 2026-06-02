# Portainer Agent

The Portainer Agent runs on a remote Docker host and allows your main Portainer CE instance to manage it.

## Port
| Port | Purpose |
|------|---------|
| 9001 | Agent communication — restrict to your Portainer CE server IP only |

```bash
sudo ufw allow from <portainer-ce-server-ip> to any port 9001
```

## Connecting to Portainer CE
1. In Portainer CE, go to Settings > Environments > Add Environment.
2. Choose Docker Standalone > Agent.
3. Set address to `<remote-server-ip>:9001`.

## Optional: Agent Secret
Uncomment in the compose file for extra security:
```yaml
AGENT_SECRET: "your-strong-secret-here"
```
Set the same secret in Portainer CE when adding the environment.

## Updating
```bash
cd ~/docker/portainer
sudo docker compose pull && sudo docker compose up -d
```
