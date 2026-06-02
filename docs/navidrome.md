# Navidrome

Navidrome is a self-hosted music streaming server compatible with any Subsonic API client.

## Port
| Port | Purpose |
|------|---------|
| 4533 | Web UI and Subsonic API |

## Data Locations
| Path | Purpose |
|---|---|
| `~/docker/navidrome/data/` | Database, config, artwork cache |
| `~/docker/navidrome/data/music/` | Music library (read-only mount) |

## Adding Music
Copy files to `~/docker/navidrome/data/music/`. Navidrome scans every 15 minutes by default.

Supported formats: MP3, FLAC, OGG, M4A, AAC, OPUS, and more.

## NPM Settings
| Setting | Value |
|---|---|
| Forward Hostname | navidrome |
| Forward Port | 4533 |
| WebSocket Support | Yes |
| Force SSL | Yes |

## Environment Variables
| Variable | Default | Purpose |
|---|---|---|
| ND_SCANINTERVAL | 15m | Scan frequency |
| ND_LOGLEVEL | info | Log verbosity |
| ND_SESSIONTIMEOUT | 24h | Idle logout time |
| TZ | UTC | Timezone |

## Updating
```bash
cd ~/docker/navidrome
sudo docker compose pull && sudo docker compose up -d
```
