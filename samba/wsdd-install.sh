#!/bin/bash
# Link: https://github.com/christgau/wsdd/issues/212

set -e

sudo apt install wsdd-server -y
sudo systemctl restart smbd
sudo systemctl enable smbd
sudo wsdd --version
./wsdd-install.sh

exit 0