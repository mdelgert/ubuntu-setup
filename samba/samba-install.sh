#!/bin/bash
# Link: https://github.com/christgau/wsdd/issues/212

set -e

SAMBA_USER="mdelgert"

sudo apt update
sudo apt-get install samba wsdd-server -y
sudo cp /etc/samba/smb.conf /etc/samba/smb.original
sudo cp smb.conf.simple /etc/samba/smb.conf
sudo systemctl restart smbd
sudo systemctl enable smbd
sudo systemctl restart wsdd-server
sudo systemctl enable wsdd-server
sudo samba --version
sudo wsdd --version
sudo smbpasswd -a $SAMBA_USER

exit 0