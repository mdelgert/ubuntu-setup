#!/bin/bash
# Update Samba
set -euo pipefail

# Copy simplified Samba config
sudo cp smb.conf.shared /etc/samba/smb.conf

# Restart and enable Samba
sudo systemctl restart smbd

exit 0