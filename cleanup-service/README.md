# Downloads Cleanup Service

A simple service to automatically delete old files from specified download directories after a configurable retention period.

## Features

- **Configurable Retention Period**: Set how many days to keep files (default: 30 days)
- **Multiple Directory Support**: Clean up multiple directories with a single service
- **Configurable Schedule**: Set when the cleanup job runs using cron syntax
- **Detailed Logging**: All deletions are logged with timestamps
- **Empty Directory Cleanup**: Automatically removes empty directories

## Configuration

The service can be configured through environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `RETENTION_DAYS` | Days to keep files before deletion | `30` |
| `CLEANUP_DIRS` | Comma-separated list of directories to clean | `/downloads/complete,/downloads/incomplete` |
| `CONFIG_PATH` | Where to store log files | `/config` |
| `CRON_SCHEDULE` | When to run the cleanup (cron syntax) | `0 0 * * *` (midnight) |

## Usage

### With Docker Compose

```yaml
downloads-cleanup:
  build:
    context: ./cleanup-service
  container_name: downloads-cleanup
  environment:
    - PUID=1000
    - PGID=1000
    - TZ=Europe/Lisbon
    - RETENTION_DAYS=30
    - CLEANUP_DIRS=/downloads/complete,/downloads/incomplete
    - CRON_SCHEDULE=0 0 * * *
  volumes:
    - ./config/downloads-cleanup:/config
    - ./downloads:/downloads
  restart: unless-stopped
```

### Building Manually

```bash
# Build the image
docker build -t downloads-cleanup ./cleanup-service

# Run the container
docker run -d \
  --name downloads-cleanup \
  -v /path/to/config:/config \
  -v /path/to/downloads:/downloads \
  -e RETENTION_DAYS=30 \
  -e CLEANUP_DIRS=/downloads/complete,/downloads/incomplete \
  -e CRON_SCHEDULE="0 0 * * *" \
  downloads-cleanup
``` 