#!/bin/bash

# This script is used to clear all logs on ubuntu system.

# Show the current size of log files
sudo du -sh /var/log
#sudo du -sh /var/log/*

# Truncate all regular log files in /var/log
sudo find /var/log -type f -exec truncate -s 0 {} \;

# Explicitly clear security-related logs
sudo truncate -s 0 /var/log/auth.log 2>/dev/null
sudo truncate -s 0 /var/log/faillog 2>/dev/null
sudo truncate -s 0 /var/log/secure 2>/dev/null
sudo rm -f /var/log/audit/* 2>/dev/null

# Remove archived/compressed logs
sudo find /var/log -type f \( -name '*.gz' -o -name '*.1' -o -name '*.old' -o -name '*.xz' \) -delete

# Clear journal logs if systemd is present
if command -v journalctl >/dev/null 2>&1; then
    sudo journalctl --rotate
    sudo journalctl --vacuum-time=1s
fi

echo "All logs have been cleared."

