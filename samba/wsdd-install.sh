#!/bin/bash
# Links: https://github.com/christgau/wsdd/issues/212
# https://github.com/christgau/wsdd

set -e

sudo apt install wsdd-server -y
sudo systemctl restart wsdd-server
sudo systemctl enable wsdd-server
sudo wsdd --version

exit 0