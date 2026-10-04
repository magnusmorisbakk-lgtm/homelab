# Minecraft Server

All the Mods 10 Minecraft server running in Docker using the `itzg/minecraft-server` image.

## Configuration

* **Modpack:** All the Mods 10
* **Container:** `minecraft-all-the-mods`
* **Memory:** 12 GB
* **Port:** `25565`
* **Restart:** `unless-stopped`

The server is configured to automatically install the modpack through CurseForge:

```yaml
TYPE: "AUTO_CURSEFORGE"
CF_SLUG: "all-the-mods-10"
```

## Storage

Active server data is stored on the SSD:

```text
/mnt/ssd/docker-volumes/game-servers/minecraft-all-the-mods
```

This is mounted to `/data` in the container.

Backups are stored separately on the HDD:

```text
/mnt/hdd/backups/minecraft-all-the-mods
```

This is mounted to `/data/simplebackups` in the container.

This keeps the active world on fast storage while storing backups on separate physical storage.

## Docker Compose

```yaml
services:
  minecraft:
    image: itzg/minecraft-server:latest
    container_name: minecraft-all-the-mods

    ports:
      - "25565:25565"

    environment:
      PUID: 1000
      PGID: 1000
      EULA: "TRUE"
      TYPE: "AUTO_CURSEFORGE"
      CF_SLUG: "all-the-mods-10"
      MEMORY: "12G"
      TZ: "Europe/Oslo"

    volumes:
      - /mnt/ssd/docker-volumes/game-servers/minecraft-all-the-mods:/data
      - /mnt/hdd/backups/minecraft-all-the-mods:/data/simplebackups

    restart: unless-stopped
    stdin_open: true
    tty: true
```
