#!/bin/bash
# Source: https://github.com/mdelgert/vpn-nsswitch
# Install script for vpn-nsswitch
# This script installs the vpn-nsswitch tool, which manages VPN connections and DNS resolution.

set -e

curl -sSL https://raw.githubusercontent.com/mdelgert/vpn-nsswitch/main/tools/install.sh | bash

exit 0