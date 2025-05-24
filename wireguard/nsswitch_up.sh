#!/bin/bash

# Script to copy nsswitch_up.conf to /etc/nsswitch.conf with logging

# Define paths and log file
NSSWITCH_FILE="/etc/nsswitch.conf"
SOURCE_FILE="/etc/nsswitch.d/nsswitch_up.conf"
LOG_FILE="/etc/nsswitch.d/nsswitch_script.log"
BACKUP_FILE="/etc/nsswitch.d/backup/nsswitch.conf.bak.$(date +%Y%m%d_%H%M%S)"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Function to log messages
log_message() {
    local level="$1"
    local message="$2"
    echo "[$TIMESTAMP] [$level] $message" | tee -a "$LOG_FILE"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    log_message "ERROR" "This script must be run as root (use sudo)."
    exit 1
fi

# Initialize log file if it doesn't exist
if [[ ! -f "$LOG_FILE" ]]; then
    touch "$LOG_FILE" 2>/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: Cannot create log file $LOG_FILE." >&2
        exit 1
    fi
    chmod 644 "$LOG_FILE"
fi

# Check if source file exists
if [[ ! -f "$SOURCE_FILE" ]]; then
    log_message "ERROR" "Source file $SOURCE_FILE does not exist."
    exit 1
fi

# Check if target file exists
if [[ ! -f "$NSSWITCH_FILE" ]]; then
    log_message "ERROR" "$NSSWITCH_FILE does not exist."
    exit 1
fi

# Create backup
log_message "INFO" "Creating backup at $BACKUP_FILE"
cp "$NSSWITCH_FILE" "$BACKUP_FILE"
if [[ $? -ne 0 ]]; then
    log_message "ERROR" "Failed to create backup at $BACKUP_FILE."
    exit 1
fi

# Copy source file to target
log_message "INFO" "Copying $SOURCE_FILE to $NSSWITCH_FILE"
cp "$SOURCE_FILE" "$NSSWITCH_FILE"
if [[ $? -ne 0 ]]; then
    log_message "ERROR" "Failed to copy $SOURCE_FILE to $NSSWITCH_FILE. Restoring backup."
    cp "$BACKUP_FILE" "$NSSWITCH_FILE"
    exit 1
fi

# Set correct permissions
chmod 644 "$NSSWITCH_FILE"
log_message "INFO" "Set permissions to 644 for $NSSWITCH_FILE"

log_message "INFO" "Script completed successfully."
exit 0