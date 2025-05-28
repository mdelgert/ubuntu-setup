#!/bin/bash
set -euo pipefail

# Enable GUFW firewall
if ! command -v gufw &> /dev/null; then
    echo "GUFW is not installed. Installing..."
    sudo apt install gufw
else
    echo "GUFW is already installed."
fi

exit 0