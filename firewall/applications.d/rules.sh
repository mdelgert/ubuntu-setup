#!/bin/bash
set -euo pipefail

DESTINATION="/etc/ufw/applications.d"

sudo mkdir -p "$DESTINATION"

for file in rdp samba; do
  if [[ -f $file ]]; then
    sudo install -m644 "$file" "$DESTINATION/$file"
  else
    echo "Warning: $file not found, skipping."
  fi
done

# Update the firewall application rules
sudo ufw app list

