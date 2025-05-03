#!/bin/bash

# Update system packages
sudo apt update && sudo apt upgrade -y

# Grant passwordless sudo to the current user
echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$(whoami)

# Install necessary packages
sudo apt install -y \
    git \
    gparted \

# Stop snap service and upgrade snap packages
sudo systemctl stop snapd
sudo snap refresh

# Install snap packages (search sudo snap find <package> for more)
sudo snap install \
    bing-wall
