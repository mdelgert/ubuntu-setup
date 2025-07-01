#!/bin/bash

# Note if ubuntu updates the kernel, you will need to re-sign the modules
# This script assumes you have already enrolled the MOK keys using vmware-mok-enroll.sh
# and that you have the MOK keys stored in ~/vmware-keys/MOK
# Must run vmware-mok-enroll.sh first to generate keys
# If make mistake run mok-reset.sh to reset MOK keys

# Show enrolled keys
mokutil --list-enrolled | grep VMware

# Sign 
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ~/vmware-keys/MOK.priv ~/vmware-keys/MOK.der $(modinfo -n vmmon)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ~/vmware-keys/MOK.priv ~/vmware-keys/MOK.der $(modinfo -n vmnet)

# Reload modules
sudo modprobe -r vmmon vmnet
sudo modprobe vmmon
sudo modprobe vmnet

# Check if modules are loaded
lsmod | grep vmmon
lsmod | grep vmnet

# Requires reboot for network to work
#sudo reboot