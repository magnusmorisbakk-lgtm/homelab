# Homelab
---

Self hosted infrastructure running on a single Ubuntu Server host.

The homelab is used to host personal services, game servers, monitoring and local AI workloads. Services are deployed as separate Docker containers and managed through Docker Compose.

The infrastructure also serves as the backend for [MoriScribe](https://github.com/magnusmorisbakk-lgtm/MoriScribe). Local system audio transcription and AI summarization. MoriScribe offloads speech to text and LLM inference to containerized services running on the GPU.

## Services
---

| **Stack** | **Service** | **Purpose** | **Interface / Port** |
| :--- | :--- | :--- | :--- |
| **Monitoring** | Grafana | Metrics visualization and dashboards | `3000:3000`|
| **Monitoring** | Prometheus | Metrics collection | `9090:9090`|
| **Monitoring** | Node Exporter | System metrics | `N/A`|
| **Monitoring** | Uptime Kuma | Service availability monitoring | `3001:3001` |
| **MoriScribe (AI)** | Whisper | Local speech to text inference | `9000:8000` |
| **MoriScribe (AI)** | Ollama | Local LLM inference | `11434:11434` |
| **Game servers** | Valheim | Dedicated game server | `2456:2456` & `2457:2457` |
| **Game servers** | Minecraft | Dedicated game server | `25565:25565` |
| **Utilities** | Syncthing | Continuous file sync across devices | `8384:8384` |



## Architecture
---

![Architecture](docs/diagrams/architecture.svg)

## System Hardware
---

| Component | Specification |
| :--- | :--- |
| **CPU** | Ryzen 5 3600 (6 Cores / 12 Threads) |
| **Memory** | 32 GB DDR4 |
| **GPU** | Nvidia RTX 2060 |
| **Storage** | 512 GB NVMe SSD + 512 GB SATA SSD + 4 TB HDD |
| **OS** | Ubuntu Server |

The GPU is primarily used for GPU accelerated AI workloads.

## Storage
---
Storage is distributed across NVMe, SATA SSD, and HDD based on workload and requirements.
* **NVMe SSD** - OS, Docker Runtime and active system data.
* **SATA SSD** - Latency sensitive workload, such as game servers.
* **HDD** - Bulk storage, persistent service data and backups.

Game server backups are stored separately from active game data.

See [Storage layout](docs/storage-layout.md) for complete storage structure.


## Networking
---
The server provides services over the local network.

[Tailscale](docs/networking/tailscale-setup.md) is used for remote access, allowing the infrastructure to be accessed without directly exposing management interfaces to the public.

## Repository Overview
---

```text
.
├── README.md
├──services/           # Docker Compose configurations
│   ├── moriscribe/
│   │     ├── ollama/
│   │     └── whisper/      
|   |     
│   ├── monitoring/
│   │       ├── grafana/ 
│   │       ├── prometheus/
│   │       ├── node-exporter/
│   │       └── uptime-kuma/
|   |
│   ├── game-servers/
│   │         ├── valheim/
│   │         └── minecraft-all-the-mods/
|   |
|   └── utilities/
|            └── syncthing/
│
└── docs/              # Infrastructure documentation
    ├── diagrams/
    ├── game-servers/
    ├── monitoring/
    ├── moriscribe/
    ├── networking/
    ├── utilities/
    └── storage-layout.md
```
Each service stack can be managed independently, allowing individual services to be updated and restarted or recreated without affecting other services.

## Management
---
`homelab.sh` provides a simple interface for managing the different service stacks.
```bash
./homelab.sh
```
This makes service management consistent and simple without requiring all services to be defined in a single Docker Compose.




