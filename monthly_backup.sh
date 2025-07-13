#!/bin/bash

# Variables
DATE=$(date +"%Y%m%d_%H%M%S")
FILENAME="MyProject_MONTHLY_$DATE.zip"
ZIPFILE="/home/ubuntu/backup_project/$FILENAME"
SOURCE_DIR="/home/ubuntu/backup_project/my_project_folder"
LOCAL_MONTHLY_DIR="/home/ubuntu/backup_project/project-backups/monthly"

# Create local directory if it doesn't exist
mkdir -p "$LOCAL_MONTHLY_DIR"

# Create zip
zip -r "$ZIPFILE" "$SOURCE_DIR"

# Log and Copy
echo "[$(date)] Monthly backup created: $FILENAME" >> /home/ubuntu/backup_project/backup_log.txt

# Upload to Google Drive
rclone copy "$ZIPFILE" gdrive:project-backups/monthly/

# Copy to local monthly folder
cp "$ZIPFILE" "$LOCAL_MONTHLY_DIR"
