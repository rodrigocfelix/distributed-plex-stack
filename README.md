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

## Directory Structure

The setup will create the following directory structure:

```
plex-stack/
├── config/
│   ├── transmission/
│   ├── sonarr/
│   ├── radarr/
│   ├── overseerr/
│   ├── bazarr/
│   ├── plex/
│   └── prowlarr/
├── downloads/
├── movies/
├── tv/
├── anime/
├── watch/
├── docker-compose.yml
└── README.md
```

## Setup Instructions

1. Create the required directories:

```bash
mkdir -p config/{transmission,sonarr,radarr,overseerr,bazarr,plex,prowlarr} downloads movies tv anime watch
```

2. Start the stack:

```bash
docker-compose up -d
```

3. Access the services:

- Plex: http://localhost:32400/web
- Transmission: http://localhost:9091
- Sonarr: http://localhost:8989
- Radarr: http://localhost:7878
- Overseerr: http://localhost:5055
- Bazarr: http://localhost:6767
- FlareSolverr: http://localhost:8191
- Prowlarr: http://localhost:9696

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

## Notes

- The default PUID and PGID are set to 1000, which is typically the first user on a Linux system. Adjust these values to match your user's ID if needed.
- You can find your user ID by running `id -u` and group ID by running `id -g` in your terminal.
- For Plex, you may need to obtain a claim token from https://plex.tv/claim and add it to the PLEX_CLAIM environment variable.
- All services are configured to restart automatically unless manually stopped.
- All services are using the host network mode, which means they are directly accessible via localhost without port mapping.
