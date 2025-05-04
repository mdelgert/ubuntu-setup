#!/bin/bash

# Install required tools
sudo apt update
sudo apt install mokutil openssl

# Check if Secure Boot is enabled
mokutil --sb-state

# If Secure Boot is enabled, generate keys
mkdir -p ~/vmware-keys
cd ~/vmware-keys
openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VMware Module Signing/"
sudo mokutil --import MOK.der

# Reboot to enroll the key
#sudo reboot