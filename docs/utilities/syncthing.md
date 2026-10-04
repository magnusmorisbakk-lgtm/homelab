# Syncthing

| Property | Value |
|----------|-------|
| **Service** | Syncthing |
| **Host Path** | `~/services/syncthing/docker-compose.yml` |
| **Web UI** | `http://YOUR_LOCAL_IP:8384` |
| **Container Name** | `syncthing` |
| **Hostname** | `my-syncthing` |

---

## Docker Compose Configuration

Syncthing is deployed as a Docker container using the official `syncthing/syncthing` image.

The Syncthing configuration and database are stored on the 4TB HDD, while the private share is mounted separately as the directory available for synchronization.

The container uses host networking, allowing Syncthing to directly use the host's network interfaces and required discovery/synchronization ports.

```yaml
services:
  syncthing:
    image: syncthing/syncthing
    container_name: syncthing
    hostname: my-syncthing

    volumes:
      - /mnt/hdd/docker-volumes/utilities/syncthing:/var/syncthing
      - /mnt/hdd/shares/private:/sync/private

    network_mode: host
    restart: unless-stopped

    healthcheck:
      test: curl -fkLsS -m 2 127.0.0.1:8384/rest/noauth/health | grep -o --color=never OK || exit 1
      interval: 1m
      timeout: 10s
      retries: 3
```

---

## Storage Layout

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `/mnt/hdd/docker-volumes/utilities/syncthing` | `/var/syncthing` | Syncthing configuration, database, and application state |
| `/mnt/hdd/shares/private` | `/sync/private` | Private files available for synchronization |

---

## Network Configuration

Syncthing runs with:

```yaml
network_mode: host
```

Because host networking is enabled, Docker does not perform individual port mappings. Syncthing binds directly to the host's network interfaces.

### Web UI

The Syncthing Web UI is available at:

```
http://localhost:8384
```

### Syncthing Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 8384 | TCP | Syncthing Web UI |
| 22000 | TCP/UDP | Device synchronization |
| 21027 | UDP | Local device discovery |
