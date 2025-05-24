#!/bin/bash

#sudo apt install wireguard openresolv
sudo mkdir -p /etc/nsswitch.d
sudo mkdir -p /etc/nsswitch.d/backup
sudo cp nsswitch_up.conf /etc/nsswitch.d/nsswitch_up.conf
sudo cp nsswitch_down.conf /etc/nsswitch.d/nsswitch_down.conf
