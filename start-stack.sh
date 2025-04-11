#!/bin/bash

# Enable BuildKit
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Build the downloads-cleanup image explicitly with BuildKit
echo "Building downloads-cleanup image with BuildKit..."
docker build -t downloads-cleanup:latest -f /cleanup-service/Dockerfile.cleanup .

# Start all services
echo "Starting all services..."
docker-compose up -d

echo "Done! Your Plex stack is now running."
echo "The downloads-cleanup service will automatically remove files older than 30 days."
echo "You can check the logs at: config/downloads-cleanup/cleanup.log"
