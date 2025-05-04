#!/bin/bash

# This script is used to enroll ventoy mok keys into the system.

#sudo mokutil --import /media/mdelgert/Ventoy/ENROLL_THIS_KEY_IN_MOKMANAGER.cer

# ls -la /media/mdelgert/
# ls -la /media/mdelgert/Ventoy/
# file /media/mdelgert/Ventoy/ENROLL_THIS_KEY_IN_MOKMANAGER.cer
# dd if=/media/mdelgert/Ventoy/ENROLL_THIS_KEY_IN_MOKMANAGER.cer bs=1 skip=44 of=/tmp/ventoy_extracted.der
# sudo mokutil --import /tmp/ventoy_extracted.der

# Show all enrolled keys
sudo mokutil --list-enrolled

# Remove all enrolled keys
sudo mokutil --reset

# Reboot the system
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
