#!/bin/bash
set -euo pipefail

# Enable UFW firewall
if ! command -v ufw &> /dev/null; then
    echo "UFW is not installed. Installing UFW and gufw..."
    sudo apt install ufw gufw
else
    echo "UFW is already installed."
fi

# Check if UFW is active
echo "Enabling UFW firewall..."
sudo ufw enable

# Allow SSH connections
echo "Allowing SSH connections through UFW..."
sudo ufw allow ssh

# Allow Samba connections
echo "Allowing Samba connections through UFW..."
sudo ufw allow samba

# Allow rdp connections
echo "Allowing RDP connections through UFW..."
sudo ufw allow 3389/tcp

exit 0