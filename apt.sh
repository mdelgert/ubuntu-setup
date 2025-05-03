#!/bin/bash

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install necessary packages
sudo apt install -y \
    git \
    gparted \
    openssh-server \
