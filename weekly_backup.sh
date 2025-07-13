#!/bin/bash

# Variables
DATE=$(date +"%Y%m%d_%H%M%S")
FILENAME="MyProject_WEEKLY_$DATE.zip"
ZIPFILE="/home/ubuntu/backup_project/$FILENAME"
SOURCE_DIR="/home/ubuntu/backup_project/my_project_folder"
LOCAL_WEEKLY_DIR="/home/ubuntu/backup_project/project-backups/weekly"

# Create local directory if it doesn't exist
mkdir -p "$LOCAL_WEEKLY_DIR"

# Create zip
zip -r "$ZIPFILE" "$SOURCE_DIR"

# Log and Copy
echo "[$(date)] Weekly backup created: $FILENAME" >> /home/ubuntu/backup_project/backup_log.txt

# Upload to Google Drive
rclone copy "$ZIPFILE" gdrive:project-backups/weekly/

# Copy to local weekly folder
cp "$ZIPFILE" "$LOCAL_WEEKLY_DIR"
