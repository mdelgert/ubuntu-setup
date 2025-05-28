#!/bin/bash
set -euo pipefail

# Remove gufw packages
sudo apt purge -y gufw
sudo apt autoremove --purge -y

exit 0