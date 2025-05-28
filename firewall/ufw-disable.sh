#!/bin/bash
set -euo pipefail

# Disable UFW firewall
if command -v ufw &> /dev/null; then
    echo "Disabling UFW firewall..."
    sudo ufw disable
else
    echo "UFW is not installed. Nothing to disable."
fi

# Remove UFW and gufw packages
if command -v apt &> /dev/null; then
    echo "Removing UFW and gufw packages..."
    sudo apt purge -y ufw gufw
    sudo apt autoremove --purge -y
else
    echo "apt command not found. Cannot remove UFW and gufw."
fi

# Remove UFW configuration files
if [ -d /etc/ufw ]; then
    echo "Removing UFW configuration files..."
    sudo rm -rf /etc/ufw
else
    echo "No UFW configuration files found."
fi

# Remove UFW log files
if [ -d /var/log/ufw ]; then
    echo "Removing UFW log files..."
    sudo rm -rf /var/log/ufw
else
    echo "No UFW log files found."
fi

exit 0