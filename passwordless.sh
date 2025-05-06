#!/bin/bash

# Grant passwordless sudo to the current user
echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$(whoami)
echo "Passwordless sudo has been granted to $(whoami)."