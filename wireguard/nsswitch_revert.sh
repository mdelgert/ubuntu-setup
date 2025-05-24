#!/bin/bash

# Script to revert changes in /etc/nsswitch.conf: remove new hosts line and uncomment original

# Define file and lines
NSSWITCH_FILE="/etc/nsswitch.conf"
ORIGINAL_LINE="hosts: files mdns4_minimal [NOTFOUND=return] dns"
COMMENTED_LINE="#${ORIGINAL_LINE}"
NEW_LINE="hosts: files dns mdns4"
BACKUP_FILE="${NSSWITCH_FILE}.bak.revert.$(date +%Y%m%d_%H%M%S)"

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

# Check if new line exists
if ! grep -Fx "$NEW_LINE" "$NSSWITCH_FILE" > /dev/null; then
    echo "Error: New line '$NEW_LINE' not found in $NSSWITCH_FILE." >&2
    exit 1
fi

# Check if commented original line exists
if ! grep -Fx "$COMMENTED_LINE" "$NSSWITCH_FILE" > /dev/null; then
    echo "Error: Commented original line not found in $NSSWITCH_FILE." >&2
    exit 1
fi

# Remove new line
sed -i "/^${NEW_LINE}/d" "$NSSWITCH_FILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to remove new line." >&2
    cp "$BACKUP_FILE" "$NSSWITCH_FILE"
    exit 1
fi

# Uncomment original line
sed -i "s/^#${ORIGINAL_LINE}/${ORIGINAL_LINE}/" "$NSSWITCH_FILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to uncomment original line." >&2
    cp "$BACKUP_FILE" "$NSSWITCH_FILE"
    exit 1
fi

# Verify changes
if grep -Fx "$ORIGINAL_LINE" "$NSSWITCH_FILE" > /dev/null && ! grep -Fx "$NEW_LINE" "$NSSWITCH_FILE" > /dev/null; then
    echo "Successfully reverted $NSSWITCH_FILE:"
    echo "Restored: $ORIGINAL_LINE"
    echo "Removed: $NEW_LINE"
else
    echo "Error: Verification failed. Restoring backup." >&2
    cp "$BACKUP_FILE" "$NSSWITCH_FILE"
    exit 1
fi

# Test SSH resolution
echo "Testing SSH resolution for b1.local..."
if getent hosts b1.local > /dev/null; then
    echo "Warning: Resolution for b1.local still succeeds. SSH may work due to other configurations." >&2
else
    echo "Resolution for b1.local failed, as expected with original mDNS settings."
fi

exit 0