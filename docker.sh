#!/bin/bash

# This script will install Docker on your system. And grant the current user access to the Docker socket.

# Check if the user is root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# Check if the system is Ubuntu
if [ -f /etc/lsb-release ]; then
    echo "Ubuntu detected"
else
    echo "This script is only for Ubuntu"
    exit
fi

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo "Docker is already installed"
    exit
fi

# Install Docker
echo "Installing Docker..."
apt-get update
apt-get install -y docker.io

# Add the current user to the Docker group
echo "Adding user to Docker group..."
usermod -aG docker $USER

# Enable and start the Docker service
echo "Enabling and starting Docker service..."
systemctl enable docker
systemctl start docker

# Check if Docker is running
if systemctl is-active --quiet docker; then
    echo "Docker is running"
else
    echo "Docker is not running"
    exit
fi

# Check if Docker is installed
if command -v docker &> /dev/null; then
    echo "Docker is installed"
else
    echo "Docker is not installed"
    exit
fi

# Check if the current user has access to the Docker socket
if docker ps &> /dev/null; then
    echo "User has access to Docker socket"
else
    echo "User does not have access to Docker socket"
    exit
fi

# Check if the current user is in the Docker group
if groups $USER | grep -q docker; then
    echo "User is in the Docker group"
else
    echo "User is not in the Docker group"
    exit
fi