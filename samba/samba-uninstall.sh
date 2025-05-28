#!/bin/bash
# Uninstalls Samba
set -euo pipefail

# Purge Samba and WSDD packages
sudo apt purge -y samba samba-common samba-common-bin
sudo apt autoremove --purge -y

# Remove Samba configuration and data directories
sudo rm -rf /etc/samba /var/log/samba /var/lib/samba

exit 0