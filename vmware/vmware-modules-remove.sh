#!/bin/bash

sudo rm -rf ~/vmware-keys

sudo mokutil --list-enrolled | grep "VMware Module Signing"

sudo mokutil --list-enrolled | grep -A5 "VMware Module Signing"

sudo mokutil --reset

sudo reboot

# During the boot process, you'll see the MOK management interface where you should:
# Select "Perform MOK management"
# Select "Reset MOK list"
# Select "Continue"
# Select "Yes" to confirm the reset
# Enter the password you just created when prompted
# Select "Reboot"
# After your system reboots, the VMware Module Signing keys will be removed from your system.
# You can verify the keys are gone by running:

sudo mokutil --list-enrolled | grep "VMware Module Signing"