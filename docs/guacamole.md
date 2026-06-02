# Apache Guacamole

Apache Guacamole is a clientless remote desktop gateway. Supports RDP, SSH, VNC, and Telnet from a browser.

## Port
| Port | Purpose |
|------|---------|
| 8080 | Web UI |

## First Login
Navigate to `http://<your-server-ip>:8080/guacamole`

```
Username: guacadmin
Password: guacadmin
```
Create a new admin account and delete guacadmin immediately.

## NPM Settings
| Setting | Value |
|---|---|
| Forward Hostname | guacamole |
| Forward Port | 8080 |
| WebSocket Support | Yes |
| Force SSL | Yes |
| HTTP/2 Support | Yes |

## Adding Connections
Settings > Connections > New Connection. Choose RDP/SSH/VNC, enter hostname, port, and credentials.

## Troubleshooting
If sessions drop immediately, WebSocket support is not enabled in NPM.
```bash
docker logs guacamole
ls -la ~/docker/guacamole/guac_config/
```
