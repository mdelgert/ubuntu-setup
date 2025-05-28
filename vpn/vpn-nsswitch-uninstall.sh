#!/bin/bash
# Source: https://github.com/mdelgert/vpn-nsswitch
# Uninstall script for vpn-nsswitch

set -e

curl -sSL https://raw.githubusercontent.com/mdelgert/vpn-nsswitch/main/tools/uninstall.sh | bash

exit 0