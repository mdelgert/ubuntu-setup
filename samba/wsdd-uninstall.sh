#!/bin/bash
# Link: https://github.com/christgau/wsdd/issues/212
set -e

sudo apt purge wsdd wsdd-server -y
./wssd-uninstall.sh

exit 0