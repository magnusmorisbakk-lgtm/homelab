# Homelab
---

Self hosted infrastructure running on a single Ubuntu Server host.

The homelab is used to host personal services, game servers, monitoring and local AI workloads. Services are deployed as isolated Docker containers and managed through Docker Compose.

## Services
---

| **Stack** | **Service** | **Purpose** |
| :--- | :--- | :--- |
| **Monitoring** | Grafana | Metrics visualization and dashboard |
| **Monitoring** | Prometheus | Metrics collection |
| **Monitoring** | Node Exporter | System metrics |
| **Monitoring** | Uptime Kuma | Service availability monitoring |
| **MoriScribe (AI)** | Whisper | Local speech to text inference |
| **MoriScribe (AI)** | Ollama | Local LLM interference |
| **Game servers** | Valheim | Dedicated game server |
| **Game servers** | Minecraft | Dedicated game server |

---

## Overview

```text
.
├── README.md
├──services/
│   ├── moriscribe
│   │     ├── ollama/
│   │     └── whisper/           
│   ├── monitoring/
│   │       ├── grafana/ 
│   │       ├── prometheus/
│   │       ├── node-exporter/
│   │       └── uptime-kuma/
│   └── game-servers/
│             ├── valheim/
│             └── minecraft-all-the-mods/
└── docs/
    ├── infrastructure-overview.md
    ├── storage-layout.md
    ├── tailscale-setup.md
    ├── ollama.md
    └── whisper.md
```
Each service stack can be managed independently, allowing individual services to be updated and restarted or recreated without affecting other services.

Persistent application data is stored outside the containers, allowing containers to be recreated or updated without losing data such as configurations, databases or AI models.

---

## Architecture

![Architecture](docs/diagrams/architecture.svg)

---
## Workflow
Management of stacks is handled through `homelab.sh`, which provides a CLI for simple operation of the individual service stacks. Each stack is configured to be independently deployable thorough its own Docker Compose configuration.

Runtime is provided by Docker. Services are isolated into separate containers and grouped into independent and grouped into independent Compose stacks based on theis specific purpose. Docker compose files remain seperate for maintainability.

Storage seperates persisten service data from their container filesystems. This allows containers to be recreated or updated without data loss.

Monitoring is provided by Prometheus, Grafana, Node Exporter and Uptime Kuma. Node Exporter exposes host metrics, Prometheus collects the metrics, Grafana provied visualization of the metrics and Uptime Kuma monitors availability of services.

AI workloads run locally on the server's GPU. MoriScribe utilizes Whisper for speech to text  transcription and Ollama for local LLM inference and transcript summarization.

Networking uses the local network for standard service acces, while Tailscale provides remote access without directly exposing management services to the public.

---
## Service stack documentation
### Monitoring

- [Monitoring Architecture](docs/monitoring.md)

### MoriScribe

- [Whisper](docs/whisper.md)
- [Ollama](docs/ollama.md)

### Game Servers

---
## Management
`homelab.sh` provides a simple interface for managing the different service stacks.
```bash
./homelab.sh
```
This makes service management consistent and simple without requiring all services to be defined in a single Docker Compose.

---
## System Hardware

| Component | Specification |
| :--- | :--- |
| **CPU** | Ryzen 5 3600 (6 Cores / 12 Threads) 
| **Memory** | 32 GB DDR4 |
| **GPU** | Nvidia RTX 2060 |
| **Storage** | 512 GB NVMe SSD + 512 GB SATA SSD + 4 TB HDD |
| **OS** | Ubuntu Server |

The gpu is primarily used for GPU accelerated AI workloads.



