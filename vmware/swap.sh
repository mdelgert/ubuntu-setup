#!/bin/bash

# VMware Swap Space Configuration Script
# This script configures a swap file for optimal VMware performance on Ubuntu.

# Check current swap space
sudo swapon --show

# Turn off swap temporarily (if needed)
echo "Turning off swap temporarily..."
sudo swapoff -a

# Create a new swap file
echo "Creating a new swap file of size 16G..."
sudo fallocate -l 16G /swap.img

# Set correct permissions
echo "Setting permissions for the swap file..."
sudo chmod 600 /swap.img

# Format the file as swap
echo "Formatting the file as swap..."
sudo mkswap /swap.img

# Enable the swap file
echo "Enabling the swap file..."
sudo swapon /swap.img

# Make it permanent
echo "Adding the swap file to /etc/fstab for persistence..."
echo "/swap.img none swap sw 0 0" | sudo tee -a /etc/fstab

# Verify the swap space
echo "Verifying the swap space..."
sudo swapon --show

# Optional: Configure VMware to use reserved host RAM
echo "To optimize VMware performance, configure virtual machines to use reserved host RAM under VMware Workstation Preferences > Memory."

echo "Swap space configuration completed successfully!"