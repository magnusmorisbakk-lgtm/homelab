

# Uptime Kuma Monitoring Setup 

**Service:** Uptime Kuma 
**Host Path:** `~/services/uptime-kuma/docker-compose.yml`  
**Dashboard URL:** `http://YOUR_LOCAL_IP:3001` 

---

## Docker Compose Configuration

The deployment uses the active `v2` image branch and mounts data to the 4TB HDD. The Docker socket is mounted as read-only (`:ro`) to allow optional container-level monitoring, though HTTP checks are preferred for API services.

```yaml
services:
  uptime-kuma:
    image: louislam/uptime-kuma:2
    container_name: uptime-kuma
    restart: unless-stopped
    ports:
      - "3001:3001"
    volumes:
      - /mnt/hdd/data/uptime-kuma:/app/data
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      - TZ=Europe/Oslo
      - UMASK=0022
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

```

## Configured Monitors


Utilizes **HTTP(s)** monitors to verify that the application layer is actively routing traffic and responding, rather than relying strictly on the Docker container's process state.

| Service Name | Monitor Type | URL Endpoint | Expected HTTP Status |
| :--- | :--- | :--- | :--- |
| **Ollama API** | HTTP(s) | `http://YOUR_LOCAL_IP:11434/api/tags` | `200-299` |
| **Whisper STT** | HTTP(s) | `http://YOUR_LOCAL_IP:9000/docs` | `200-299` |
| **Valheim Server** | Docker Container | Container Name: valheim-server | | Container Running `UP` |
| **Grafana** | Docker Container | Container Name: grafana | Container Running `UP` |
| **Prometheus** | Docker Container | Container Name: prometheus | Container Running `UP` |
| **Node Exporter** | Docker Container | Container Name: node_exporter | Container Running `UP` |
| **Syncthing** | Docker Container | Container Name: syncthing | Container Running `UP` |

**Global Monitor Settings:**

-   **Interval:** 60 seconds
    
-   **Retries:** 3 consecutive failures before marking as `DOWN`
    

## Discord Alerting Integration

Status changes are broadcast directly to the server's Discord structure.

-   **Target Channel:** `Homelab` $\rightarrow$ `#moriscribe`
    
-   **Trigger Conditions:** Service goes offline (DOWN) after 3 retries, or service recovers (UP).
    
