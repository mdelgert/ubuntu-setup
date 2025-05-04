#!/bin/bash

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