#!/bin/bash

# Script to configure Ubuntu to not suspend when the laptop lid is closed
# Adds or updates the necessary lines in /etc/systemd/logind.conf
# https://itsfoss.com/laptop-lid-suspend-ubuntu/
CONFIG_FILE="/etc/systemd/logind.conf"

# Backup the original file
sudo cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"

# Add or update the lid switch settings
sudo sed -i '/^#*HandleLidSwitch=/d' "$CONFIG_FILE"
sudo sed -i '/^#*HandleLidSwitchExternalPower=/d' "$CONFIG_FILE"
sudo sed -i '/^#*HandleLidSwitchDocked=/d' "$CONFIG_FILE"

echo "HandleLidSwitch=ignore" | sudo tee -a "$CONFIG_FILE"
echo "HandleLidSwitchExternalPower=ignore" | sudo tee -a "$CONFIG_FILE"
echo "HandleLidSwitchDocked=ignore" | sudo tee -a "$CONFIG_FILE"

# Restart the logind service to apply changes
# sudo systemctl restart systemd-logind

echo "Lid switch settings updated and logind service restarted."