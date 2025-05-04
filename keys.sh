#!/bin/bash

# This script will copy keys to the .ssh directory and set the correct permissions

# Define the source directory for keys
KEYS_SOURCE_DIR="/media/mdelgert/Ventoy/ssh"

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
