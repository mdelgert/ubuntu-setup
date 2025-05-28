#!/bin/bash
# Link: https://github.com/christgau/wsdd/issues/212

set -e

sudo apt install wsdd-server -y
sudo systemctl restart wsdd-server
sudo systemctl enable wsdd-server
sudo wsdd --version

exit 0