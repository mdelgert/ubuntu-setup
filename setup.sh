#!/bin/bash

# Run sudo.sh grant passwordless sudo to the current user
bash ./sudo.sh

# Run chmod.sh make all scripts executable
bash ./chmod.sh

# Setup ssh keys
bash ./keys.sh

# Run apt.sh to update and install packages
bash ./apt.sh

# Run git.sh to setup git
bash ./git.sh

# Run snap.sh to update and install snap packages
bash ./snap.sh