#!/bin/bash

# Script to modify /etc/nsswitch.conf: comment out specific hosts line and add new one

# Define file and lines
NSSWITCH_FILE="/etc/nsswitch.conf"
ORIGINAL_LINE="files mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns"
NEW_LINE="hosts: files dns mdns4"
BACKUP_FILE="${NSSWITCH_FILE}.bak.$(date +%Y%m%d_%H%M%S)"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root (use sudo)." >&2
    exit 1
fi

# Check if file exists
if [[ ! -f "$NSSWITCH_FILE" ]]; then
    echo "Error: $NSSWITCH_FILE does not exist." >&2
    exit 1
fi

# Create backup
cp "$NSSWITCH_FILE" "$BACKUP_FILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create backup at $BACKUP_FILE." >&2
    exit 1
fi
echo "Backup created at $BACKUP_FILE"

# Check if original line exists
if ! grep -Fx "$ORIGINAL_LINE" "$NSSWITCH_FILE" > /dev/null; then
    echo "Error: Original line not found in $NSSWITCH_FILE." >&2
    exit 1
fi

# Check if new line already exists to avoid duplicates
if grep -Fx "$NEW_LINE" "$NSSWITCH_FILE" > /dev/null; then
    echo "Warning: New line '$NEW_LINE' already exists in $NSSWITCH_FILE. No changes made." >&2
    exit 0
fi

# Comment out original line and add new line
sed -i "/^${ORIGINAL_LINE}/ s/^/#/" "$NSSWITCH_FILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to comment out original line." >&2
    cp "$BACKUP_FILE" "$NSSWITCH_FILE"
    exit 1
fi

echo "$NEW_LINE" >> "$NSSWITCH_FILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to add new line." >&2
    cp "$BACKUP_FILE" "$NSSWITCH_FILE"
    exit 1
fi

# Verify changes
if grep -Fx "#${ORIGINAL_LINE}" "$NSSWITCH_FILE" > /dev/null && grep -Fx "$NEW_LINE" "$NSSWITCH_FILE" > /dev/null; then
    echo "Successfully modified $NSSWITCH_FILE:"
    echo "Commented out: $ORIGINAL_LINE"
    echo "Added: $NEW_LINE"
else
    echo "Error: Verification failed. Restoring backup." >&2
    cp "$BACKUP_FILE" "$NSSWITCH_FILE"
    exit 1
fi

# Test SSH resolution
echo "Testing SSH resolution for b1.local..."
if getent hosts b1.local > /dev/null; then
    echo "Resolution for b1.local succeeded. Try 'ssh b1.local' to confirm."
else
    echo "Warning: Resolution for b1.local failed. SSH may still not work." >&2
fi

exit 0