#!/bin/bash
# Uninstalls Samba and WSDD, and removes related configuration and data

set -euo pipefail

# Purge Samba and WSDD packages
sudo apt purge -y samba samba-common samba-common-bin wsdd wsdd-server
sudo apt autoremove --purge -y

# Remove Samba configuration and data directories
sudo rm -rf /etc/samba /var/log/samba /var/lib/samba

exit 0