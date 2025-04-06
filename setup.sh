#!/bin/bash

# Create directory structure for Plex media stack
echo "Creating directory structure for Plex media stack..."
mkdir -p config/{transmission,sonarr,radarr,overseerr,bazarr,plex} downloads movies tv watch

# Set permissions (optional - uncomment if needed)
# echo "Setting permissions..."
# chmod -R 777 config downloads movies tv watch anime

echo "Directory structure created successfully!"
echo ""
echo "To start your Plex media stack, run:"
echo "docker-compose up -d"
echo ""
echo "Access your services at:"
echo "- Plex: http://localhost:32400/web"
echo "- Transmission: http://localhost:9091"
echo "- Sonarr: http://localhost:8989"
echo "- Radarr: http://localhost:7878"
echo "- Overseerr: http://localhost:5055"
echo "- Bazarr: http://localhost:6767"
echo "- FlareSolverr: http://localhost:8191"
echo ""
echo "See README.md for detailed configuration instructions."
