#!/bin/bash
set -euo pipefail

sudo ufw status numbered
sudo ufw delete allow ssh
sudo ufw delete allow samba
sudo ufw delete allow 3389/tcp
sudo ufw disable

exit 0