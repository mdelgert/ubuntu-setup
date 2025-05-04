#!/bin/bash

# Stop snap service and upgrade snap packages
sudo systemctl stop snapd
sudo snap refresh

# Install snap packages (search sudo snap find <package> for more)
sudo snap install \
    code \
    bing-wall \
    kdiskmark \
    remmina \