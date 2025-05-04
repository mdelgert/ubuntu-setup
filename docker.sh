#!/bin/bash

# This script will install Docker on Ubuntu 24.04.2 LTS. And grant the current user access to the Docker socket.

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
else
    # Install Docker
    echo "Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io

    # Add the current user to the Docker group
    echo "Adding user to Docker group..."
    sudo usermod -aG docker $USER

    # Enable and start the Docker service
    echo "Enabling and starting Docker service..."
    sudo systemctl enable docker
    sudo systemctl start docker

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
fi

# Update Docker Compose installation to use docker-compose-v2
DOCKER_COMPOSE_PACKAGE="docker-compose-v2"
echo "Installing Docker Compose v2..."
sudo apt-get update
sudo apt-get install -y $DOCKER_COMPOSE_PACKAGE

# Verify Docker Compose v2 installation
echo "Verifying Docker Compose v2 installation..."
if docker compose version &> /dev/null; then
    echo "Docker Compose v2 is installed"
else
    echo "Docker Compose v2 installation failed"
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