#!/bin/bash

# This script will copy keys to the .ssh directory and set the correct permissions

# Define the source directory for keys
KEYS_SOURCE_DIR="/media/mdelgert/06e553b3-c8d2-475e-b98f-245551938440/downloads/ssh"

# Check if the .ssh directory exists
if [ ! -d "$HOME/.ssh" ]; then
  mkdir -p "$HOME/.ssh"
fi
# Copy the keys to the .ssh directory
cp -r "$KEYS_SOURCE_DIR"/* "$HOME/.ssh/"

# Set the correct permissions
chmod 700 "$HOME/.ssh"

# Set the correct permissions for all files in the .ssh directory if they exist
if [ "$(ls -A $HOME/.ssh)" ]; then
  chmod 600 "$HOME/.ssh"/*
fi
