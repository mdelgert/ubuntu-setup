#!/bin/bash

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install necessary packages
sudo apt install -y \
    curl \
    git \
    openssh-server \
    gparted \
    gdebi \
    gdebi-core \
    rpi-imager
    