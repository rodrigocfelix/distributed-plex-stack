#!/bin/sh

# Script to delete files in specified download folders that are older than the retention period
# This helps automatically stop seeding torrents after a certain period and free up disk space

# Default to 30 days if RETENTION_DAYS is not set
RETENTION_DAYS=${RETENTION_DAYS:-30}

# Default paths if not set in environment
CONFIG_DIR=${CONFIG_PATH:-"/config"}
LOG_FILE="${CONFIG_DIR}/cleanup.log"

# Get the directories to clean (comma-separated list)
# Default to downloads/complete and downloads/incomplete if not specified
CLEANUP_DIRS=${CLEANUP_DIRS:-"/downloads/complete,/downloads/incomplete"}

echo "$(date): Starting cleanup of files older than ${RETENTION_DAYS} days" >> $LOG_FILE

# Convert comma-separated list to space-separated for iteration
CLEANUP_DIRS=$(echo $CLEANUP_DIRS | tr ',' ' ')

# Process each directory
for DIR in $CLEANUP_DIRS; do
  echo "$(date): Processing directory: ${DIR}" >> $LOG_FILE
  
  # Check if directory exists
  if [ ! -d "$DIR" ]; then
    echo "$(date): Directory does not exist, skipping: ${DIR}" >> $LOG_FILE
    continue
  fi
  
  # Find and delete files older than RETENTION_DAYS
  find "$DIR" -type f -mtime +$RETENTION_DAYS -exec rm -f {} \; -exec echo "$(date): Deleted: {}" >> $LOG_FILE \;
  
  # Find and delete empty directories
  find "$DIR" -type d -empty -delete -exec echo "$(date): Deleted empty directory: {}" >> $LOG_FILE \;
done

echo "$(date): Cleanup completed" >> $LOG_FILE
