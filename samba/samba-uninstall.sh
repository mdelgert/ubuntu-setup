#!/bin/bash

# Exit on any error
set -e

sudo apt purge samba samba-common samba-common-bin -y
sudo apt autoremove --purge -y
sudo rm -rf /etc/samba /var/log/samba /var/lib/samba
./wsdd-uninstall.sh

exit 0