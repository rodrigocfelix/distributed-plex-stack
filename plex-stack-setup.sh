#!/bin/bash

set -e

# Variables
DISK="/dev/sdb"
MOUNT_POINT="./media"
CONFIG_PATH="./config"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
ABSOLUTE_MOUNT_POINT="$SCRIPT_DIR/media"

echo "🚨 This will erase all data on $DISK. Are you sure? (yes/no)"
read -r CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
  echo "Aborted."
  exit 1
fi

echo "🧹 Wiping and creating GPT partition on $DISK..."
sudo wipefs -a $DISK
echo -e "o\ny\nn\n\n\n\nw\ny\n" | sudo gdisk $DISK

PARTITION="${DISK}1"

echo "📦 Formatting $PARTITION as ext4..."
sudo mkfs.ext4 $PARTITION

echo "📂 Creating mount point at $MOUNT_POINT..."
mkdir -p "$ABSOLUTE_MOUNT_POINT"

echo "🔗 Mounting $PARTITION..."
sudo mount $PARTITION "$ABSOLUTE_MOUNT_POINT"

echo "🔐 Getting UUID..."
UUID=$(sudo blkid -s UUID -o value $PARTITION)

echo "📝 Adding entry to /etc/fstab..."
FSTAB_LINE="UUID=$UUID $ABSOLUTE_MOUNT_POINT ext4 defaults 0 2"
if ! grep -q "$UUID" /etc/fstab; then
  echo "$FSTAB_LINE" | sudo tee -a /etc/fstab
fi

echo "📁 Creating config folders..."
mkdir -p "$CONFIG_PATH"/{transmission,sonarr,radarr,overseerr,bazarr,plex,prowlarr,portainer,downloads-cleanup,flaresolverr}

echo "📁 Creating media folders..."
mkdir -p "$ABSOLUTE_MOUNT_POINT"/{downloads,movies,tv,anime,watch}
mkdir -p "$ABSOLUTE_MOUNT_POINT/downloads"/{complete,incomplete}

echo "🔧 Setting permissions..."
sudo chown -R 1000:1000 "$ABSOLUTE_MOUNT_POINT"
sudo chown -R 1000:1000 "$CONFIG_PATH"

echo "👑 Setting ownership..."
sudo chown -R "$USER:$USER" .

echo "✅ Setup complete! You can now run docker-compose up -d to start the Plex stack."
