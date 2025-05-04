#!/bin/bash

# This script is used to enroll ventoy mok keys into the system.

#sudo mokutil --import /media/mdelgert/Ventoy/ENROLL_THIS_KEY_IN_MOKMANAGER.cer

# ls -la /media/mdelgert/
# ls -la /media/mdelgert/Ventoy/
# file /media/mdelgert/Ventoy/ENROLL_THIS_KEY_IN_MOKMANAGER.cer
# dd if=/media/mdelgert/Ventoy/ENROLL_THIS_KEY_IN_MOKMANAGER.cer bs=1 skip=44 of=/tmp/ventoy_extracted.der
# sudo mokutil --import /tmp/ventoy_extracted.der