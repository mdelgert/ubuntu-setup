#!/bin/bash

# https://community.hetzner.com/tutorials/getting-started-with-veeam/installing-the-veeam-agent-for-linux

# Define variables
VEEAM_INSTALLER="./veeam-release-deb_1.0.9_amd64.deb"

sudo dpkg -i $VEEAM_INSTALLER
sudo apt-get update
sudo apt-get install xorriso cifs-utils blksnap veeam

# Reboot the system and enroll Veeam mok key
sudo reboot

# After reboot run veam sudo veeam