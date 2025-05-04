#!/bin/bash

# Script to install Docker using the convenience script, check for curl, and grant user permissions

echo "Checking for curl..."
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Installing curl..."
    sudo apt-get update
    sudo apt-get install -y curl
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install curl. Please check your network or package manager."
        exit 1
    fi
else
    echo "curl is already installed."
fi

echo "Running Docker convenience script..."
curl -fsSL https://get.docker.com | sh

if [ $? -ne 0 ]; then
    echo "Error: Convenience script failed. Check network or script output."
    exit 1
fi

echo "Adding current user to docker group..."
sudo usermod -aG docker $USER

echo "Verifying Docker installation..."
docker --version

echo "Verifying Docker Compose installation..."
docker compose version

echo "Docker and Docker Compose installed successfully."
echo "Log out and back in to use Docker without sudo or reboot."
echo "Test Docker with: docker run hello-world"