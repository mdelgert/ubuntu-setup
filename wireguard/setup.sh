#!/bin/bash

#sudo apt install wireguard openresolv

# Setup directories
sudo mkdir -p /etc/nsswitch.d
sudo mkdir -p /etc/nsswitch.d/backup

# Setup nsswitch up files
sudo chmod +x nsswitch_up.sh
sudo cp nsswitch_up.sh /etc/nsswitch.d/nsswitch_up.sh
sudo cp nsswitch_up.conf /etc/nsswitch.d/nsswitch_up.conf

# Setup nsswitch down files
sudo chmod +x nsswitch_down.sh
sudo cp nsswitch_down.sh /etc/nsswitch.d/nsswitch_down.sh
sudo cp nsswitch_down.conf /etc/nsswitch.d/nsswitch_down.conf
