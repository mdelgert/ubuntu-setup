#!/bin/bash

# Exit on any error
set -e

SAMBA_USER="mdelgert"

sudo apt update
sudo apt-get install samba -y
sudo cp /etc/samba/smb.conf /etc/samba/smb.original
sudo cp smb.conf.simple /etc/samba/smb.conf
sudo systemctl restart smbd
sudo systemctl enable smbd
sudo samba --version
# sudo smbpasswd -a $SAMBA_USER
# ./wsdd-install.sh

exit 0