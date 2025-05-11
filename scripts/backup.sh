#!/bin/bash

# Backup Script for Ubuntu
# This script uses rsync to backup files and includes logging, error handling, and email notifications.

# Set variables
SOURCE_DIR="/home/mdelgert/source"  # Replace with the source directory
DEST_DIR="/mnt/d1/backup"  # Replace with the destination directory
LOG_FILE="$DEST_DIR/backup.log"
EMAIL="your_email@example.com"  # Replace with your email address

# Create log file if it doesn't exist
touch "$LOG_FILE"

# Function to send email notifications
send_email() {
    local subject="$1"
    local message="$2"
    echo -e "$message" | mail -s "$subject" "$EMAIL"
}

# Start logging
echo "Backup started at $(date)" >> "$LOG_FILE"

# Perform the backup using rsync
rsync -avh --delete "$SOURCE_DIR" "$DEST_DIR" >> "$LOG_FILE" 2>&1

# Check if rsync was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully at $(date)" >> "$LOG_FILE"
else
    echo "Backup failed at $(date)" >> "$LOG_FILE"
    send_email "Backup Failed" "The backup process failed. Check the log file at $LOG_FILE for details."
    exit 1
fi

# End logging
echo "Backup script finished at $(date)" >> "$LOG_FILE"

exit 0
