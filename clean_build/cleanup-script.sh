#!/bin/sh

# Script to delete files in the downloads folder that are older than the specified time
# This helps automatically stop seeding torrents after a certain period and free up disk space

# Default to 30 days if RETENTION_DAYS is not set
RETENTION_DAYS=${RETENTION_DAYS:-30}
DOWNLOADS_DIR="/downloads"

# Log file is stored in /config which is mounted from the host
# This ensures logs persist across container restarts/rebuilds
LOG_FILE="/config/cleanup.log"

echo "$(date): Starting cleanup of files older than ${RETENTION_DAYS} days in ${DOWNLOADS_DIR}" >> $LOG_FILE

# Find and delete files older than RETENTION_DAYS
find $DOWNLOADS_DIR -type f -mtime +$RETENTION_DAYS -exec rm -f {} \; -exec echo "$(date): Deleted: {}" >> $LOG_FILE \;

# Find and delete empty directories (optional, comment out if not needed)
find $DOWNLOADS_DIR -type d -empty -delete -exec echo "$(date): Deleted empty directory: {}" >> $LOG_FILE \;

echo "$(date): Cleanup completed" >> $LOG_FILE
