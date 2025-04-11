# Plex Media Stack

This Docker Compose setup includes a complete media management stack with the following components:

- **Plex**: Media server for streaming your content
- **Transmission**: Torrent client for downloading media
- **Sonarr**: TV series management and automation
- **Radarr**: Movie management and automation
- **Overseerr**: Media request and user management system
- **Bazarr**: Subtitle management and automation
- **FlareSolverr**: Captcha solving service for your *arr applications
- **Prowlarr**: Indexer manager and proxy for your *arr applications
- **Portainer**: Docker container management UI
- **Tailscale Check**: Ensures VPN routing through Switzerland before starting Transmission
- **Downloads Cleanup**: Automatically removes old downloads based on retention policy

## Directory Structure

The setup will create the following directory structure:

```
project-directory/
├── config/               # Container configurations
│   ├── transmission/
│   ├── sonarr/
│   ├── radarr/
│   ├── overseerr/
│   ├── bazarr/
│   ├── plex/
│   ├── prowlarr/
│   ├── portainer/
│   ├── flaresolverr/
│   └── downloads-cleanup/
├── media/                # External HDD mount point
│   ├── downloads/        # Downloaded content
│   │   ├── complete/     # Completed downloads
│   │   └── incomplete/   # In-progress downloads
│   ├── movies/           # Movie library
│   ├── tv/               # TV shows library
│   ├── anime/            # Anime library
│   └── watch/            # Watch directory for transmission
├── docker-compose.yml
├── plex-stack-setup.sh   # Setup script for external HDD
└── README.md
```

## Setup Instructions

1. Clone this repository to any location on your system:

```bash
git clone https://github.com/yourusername/plex-stack.git
cd plex-stack
```

2. Run the setup script to configure the external HDD (this will erase all data on the specified disk):

```bash
chmod +x plex-stack-setup.sh
./plex-stack-setup.sh
```

The setup script will:
- Format and mount the external HDD at `./media` in your project directory
- Create the necessary directory structure
- Set appropriate permissions
- Configure the mount to persist across reboots

3. Start the stack:

```bash
docker-compose up -d
```

4. Access the services:

- Plex: http://localhost:32400/web
- Transmission: http://localhost:9091
- Sonarr: http://localhost:8989
- Radarr: http://localhost:7878
- Overseerr: http://localhost:5055
- Bazarr: http://localhost:6767
- FlareSolverr: http://localhost:8191
- Prowlarr: http://localhost:9696
- Portainer: http://localhost:9000

## Configuration

### Plex

1. Access Plex at http://localhost:32400/web
2. Follow the setup wizard to create your server
3. Add your media libraries pointing to:
   - Movies: `/movies`
   - TV Shows: `/tv`
   - Anime: `/anime`

### Sonarr/Radarr

1. Add Transmission as a download client:
   - Host: `localhost`
   - Port: `9091`
   - URL Path: `/transmission/rpc`

2. Add FlareSolverr as a proxy (in settings):
   - Host: `localhost`
   - Port: `8191`

3. Configure your media paths:
   - Sonarr: `/tv`
   - Radarr: `/movies`
   - Downloads: `/downloads`

### Overseerr

1. Connect to your Plex server
2. Add Sonarr and Radarr instances:
   - URL: `http://localhost:8989` or `http://localhost:7878`
   - API Key: Found in Settings > General in Sonarr/Radarr

### Bazarr

1. Configure Sonarr and Radarr connections:
   - URL: `http://localhost:8989` or `http://localhost:7878`
   - API Key: Found in Settings > General in Sonarr/Radarr

### Prowlarr

1. Access Prowlarr at http://localhost:9696
2. Add your indexers (torrent sites, usenet providers, etc.)
3. Connect your *arr applications:
   - Go to Settings > Apps
   - Add Sonarr, Radarr, etc. with their respective URLs and API keys:
     - URL: `http://localhost:8989` or `http://localhost:7878`
     - API Key: Found in Settings > General in each application

### Portainer

1. Access Portainer at http://localhost:9000
2. Create an admin account during the first-time setup
3. Choose "Local" as the environment to manage
4. You'll now have a web interface to:
   - Monitor all your containers
   - View logs of running containers
   - Manage container lifecycle (start, stop, restart)
   - Access container consoles
   - View performance metrics

### Tailscale VPN Integration

The stack includes a Tailscale check service that ensures your traffic is routed through Switzerland before Transmission starts:

1. Make sure Tailscale is installed and running on your host machine
2. Configure Tailscale to use the Mullvad exit node (ch-zrh-wg-201.mullvad.ts.net)
3. The tailscale-check service automatically:
   - Verifies your traffic is routed through Switzerland
   - Prevents Transmission from starting until the correct routing is confirmed
   - Logs the status during startup

To manually set up Tailscale with the exit node:
```bash
tailscale up --exit-node=ch-zrh-wg-201.mullvad.ts.net --exit-node-allow-lan-access=true
```

### Downloads Cleanup Service

The Downloads Cleanup service automatically removes old files from your downloads directories:

1. Configuration is handled through environment variables:
   - `RETENTION_DAYS`: How long to keep files (default: 30 days)
   - `CLEANUP_DIRS`: Which directories to clean (default: downloads/complete,downloads/incomplete)
   - `CRON_SCHEDULE`: When to run the cleanup job (default: 5 AM daily)

2. The service logs all cleanup activities to the config directory
3. Files older than the retention period are automatically deleted
4. The service runs as a scheduled task based on the cron schedule

## Notes

- The default PUID and PGID are set to 1000, which is typically the first user on a Linux system. Adjust these values to match your user's ID if needed.
- You can find your user ID by running `id -u` and group ID by running `id -g` in your terminal.
- For Plex, you may need to obtain a claim token from https://plex.tv/claim and add it to the PLEX_CLAIM environment variable.
- All services are configured to restart automatically unless manually stopped.
- All services are using the host network mode, which means they are directly accessible via localhost without port mapping.
