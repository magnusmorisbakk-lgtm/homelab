
# Server Storage Architecture & Layout

**Last Updated:** 4. October 2026  
**System:** Ubuntu Server  

## Hardware & Drive Overview
---
| Drive Identifier | Capacity | Type | Filesystem | Mount Point | Primary Purpose |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `/dev/nvme0n1` | ~500 GB | NVMe SSD | `ext4` | `/` | OS, Docker, active application data|
| `/dev/sda`| ~500 GB | SATA SSD | `ext4` | `/mnt/ssd` | Game servers, latency sensitive data |
| `/dev/sdb` | 4.0 TB | Mechanical HDD | `ext4` | `/mnt/hdd` | Bulk storage, persistent data and backups |

The storage layout is designed around the capabilities of the three drives and the needs of the services.

The NVMe is used for the OS and Docker Runtime.The SATA SSD is used for  workloads that require or benefit from faster storage. The HDD is used for larger datasets and static service data where capacity is more important than performance.


## NVMe SSD 
---
* `/`: Main root system directory.
* `/boot` & `/boot/efi`: EFI System Partition and Linux kernel images 
* `/var/lib/docker/`: Docker Engine, container image layers and runtime data.
* `/home/YOUR_USERNAME/`: User home directory, dotfiles, and active development source code.

Docker remains on the SSD, since it provides faster access to container images and their filesystems

Certain services may have their data stored seperately on the HDD, where the workload has a low demand and benefits from capacity.


## SATA SSD
---
Mounted at:
`/mnt/ssd`
Used for workloads that benefit from higher IOPS and lower latency.

### Directory structure

```text
/mnt/ssd/
└── docker-volumes/   
    └── game-servers/
        ├── minecraft-all-the-mods/
        └── valheim/
```



## 4 TB HDD 
---
Mounted at:
`/mnt/hdd`

Primarily used for bulk storage, static service data and backups.

### Directory Structure HDD

```text
/mnt/hdd/
├── docker-volumes/                                      
|   │       
|   ├── monitoring/                
|   │   ├── grafana/              
|   │   ├── prometheus/           
|   │   └── uptime-kuma/           
|   │
|   └── moriscribe/               
|       ├── ollama/                       
|       └── whisper/               
|
└── backups/
        └── minecract-all-the-mods/
```


The directories under `docker-volumes/` contain data that must persist outside of the containers themselves.

This ensures that game server worlds, Grafana configuration and AI models remain intact if containers are removed or recreated.

## Storage Strategy
---
The general storage strategy can be represented as:
```text
                       [ Ubuntu Server ]
                               │
         ┌─────────────────────┼─────────────────────┐
         │                     │                     │
    [ NVMe SSD ]          [ SATA SSD ]          [  4 TB HDD  ]
         │                     │                     │
    [ Ubuntu System ]     [ Game servers ]    [ Persistent data ]
    [    (OS)       ]                         [  Local Backups  ]
    [Docker runtime ]                         [   Bulk data     ]    
```

### Design principles
1. Keep the OS and Docker runtime on fast storage.
2. Keep persistent service data outside of their containers.
3. Use the HDD for large or data, or data that is relatively static.
4. Allow containers to be recreated without losing static data.
5. Use SSD storage where latency has a meaningful impact on the workload or is necessary for proper function.

The meaning of these choices is to make individual services easier to maintain and make them easier to move between storage devices, if requirements related to performance or capacity changes.