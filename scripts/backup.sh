#!/bin/bash

BACKUP_PATH="$HOME/Documents/Backup"
FILENAME=$(date +%Y-%m-%d_%H-%M-%S)

read -p "Enter folder to backup: " FOLDER

# Validate directory
[ ! -d "$HOME/$FOLDER" ] && { echo "Invalid folder."; exit 1;}
TARGET="$HOME/$FOLDER"

# Create directory
mkdir -p "$BACKUP_PATH"

# Compress directory
tar -czvf "$BACKUP_PATH/$FILENAME.tar.gz" "$TARGET"

# Keep last 5
(cd "$BACKUP_PATH" && ls -1tr | head -n -5 | xargs rm -f)

# Upload to remote server
REMOTE_USER=""
REMOTE_HOST=""
REMOTE_DIR=""

# scp whatever

# Automate
(cron @hourly "$HOME/documents/bash/backup1.sh")
(systemctl status cron)

# Verify script is running
