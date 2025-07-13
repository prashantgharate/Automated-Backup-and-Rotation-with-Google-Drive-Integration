#!/bin/bash

# Variables
DATE=$(date +"%Y%m%d_%H%M%S")
FILENAME="MyProject_DAILY_$DATE.zip"
ZIPFILE="/home/ubuntu/backup_project/$FILENAME"
SOURCE_DIR="/home/ubuntu/backup_project/my_project_folder"
LOCAL_DAILY_DIR="/home/ubuntu/backup_project/project-backups/daily"

# Create local daily folder if it doesn't exist
mkdir -p "$LOCAL_DAILY_DIR"

# Create the zip archive
zip -r "$ZIPFILE" "$SOURCE_DIR"

# Log the operation
echo "[$(date)] Daily backup created: $FILENAME" >> /home/ubuntu/backup_project/backup_log.txt

# Upload to Google Drive
rclone copy "$ZIPFILE" gdrive:project-backups/daily/

# Copy locally to daily folder
cp "$ZIPFILE" "$LOCAL_DAILY_DIR"
