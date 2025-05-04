#!/bin/bash

# Simple script to sign VMware kernel modules for Secure Boot on Ubuntu
# Runs as regular user, uses sudo for privileged operations, no prompts
# Syntax checked with: bash -n sign-vmware-modules.sh
# Line count: ~145 lines

# Ensure script is not sourced
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
    echo "ERROR: This script must be executed, not sourced. Run with: ./sign-vmware-modules.sh"
    return 1 2>/dev/null || exit 1
fi

set -e

KEY_DIR="$HOME/vmware-keys"
MOK_PRIV="$KEY_DIR/MOK.priv"
MOK_DER="$KEY_DIR/MOK.der"
LOG_FILE="$HOME/vmware-module-signing.log"
KERNEL_VERSION=$(uname -r)

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    echo "$1"
}

log_message "Starting VMware module signing process..."

# Check Secure Boot
log_message "Checking Secure Boot status..."
if ! command -v mokutil >/dev/null 2>&1; then
    log_message "ERROR: mokutil not installed."
    exit 1
fi
if ! mokutil --sb-state | grep -q "SecureBoot enabled"; then
    log_message "Secure Boot is disabled. No signing required."
    exit 0
fi

# Install packages
log_message "Installing required packages..."
sudo apt update || { log_message "ERROR: Failed to update package list."; exit 1; }
sudo apt install -y mokutil openssl linux-headers-"$KERNEL_VERSION" || { log_message "ERROR: Failed to install packages."; exit 1; }

# Generate signing key (only if needed or signatures invalid)
log_message "Checking for existing signing key..."
if [[ -f "$MOK_PRIV" ]] && [[ -f "$MOK_DER" ]]; then
    if modinfo vmmon 2>/dev/null | grep -q "signature" && modinfo vmnet 2>/dev/null | grep -q "signature"; then
        log_message "Existing signing key found and modules signed. Skipping key generation."
    else
        log_message "Signatures invalid or MOK not enrolled. Regenerating signing key..."
        mkdir -p "$KEY_DIR" || { log_message "ERROR: Failed to create key directory."; exit 1; }
        cd "$KEY_DIR" || { log_message "ERROR: Failed to change to key directory."; exit 1; }
        rm -f MOK.priv MOK.der
        openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VMware Module Signing/" || { log_message "ERROR: Failed to generate signing key."; exit 1; }
    fi
else
    log_message "Generating signing key..."
    mkdir -p "$KEY_DIR" || { log_message "ERROR: Failed to create key directory."; exit 1; }
    cd "$KEY_DIR" || { log_message "ERROR: Failed to change to key directory."; exit 1; }
    rm -f MOK.priv MOK.der
    openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VMware Module Signing/" || { log_message "ERROR: Failed to generate signing key."; exit 1; }
fi

# Enroll MOK key if needed
log_message "Checking MOK enrollment..."
if ! mokutil --list-enrolled | grep -q "VMware Module Signing"; then
    log_message "Enrolling MOK key..."
    if [[ ! -f "$MOK_DER" ]]; then
        log_message "ERROR: MOK.der not found."
        exit 1
    fi
    sudo mokutil --import "$MOK_DER" || { log_message "ERROR: Failed to import MOK key."; exit 1; }
    log_message "MOK key imported. Rebooting to enroll key..."
    echo "After reboot, in MOK manager:"
    echo "1. Select 'Enroll MOK'"
    echo "2. Select 'Continue'"
    echo "3. Select 'Yes'"
    echo "4. Enter the password you set"
    echo "5. Reboot again and rerun this script"
    sudo reboot
fi

# Verify MOK enrollment
log_message "Verifying MOK enrollment..."
if ! mokutil --list-enrolled | grep -q "VMware Module Signing"; then
    log_message "ERROR: MOK key not enrolled. Please enroll the key in MOK manager and rerun the script."
    exit 1
fi

# Sign modules
log_message "Signing VMware modules..."
VMMON_PATH=$(modinfo -n vmmon 2>/dev/null) || { log_message "ERROR: vmmon module not found. Ensure VMware Workstation is installed."; exit 1; }
VMNET_PATH=$(modinfo -n vmnet 2>/dev/null) || { log_message "ERROR: vmnet module not found. Ensure VMware Workstation is installed."; exit 1; }
SIGN_SCRIPT="/usr/src/linux-headers-$KERNEL_VERSION/scripts/sign-file"
if [[ ! -f "$SIGN_SCRIPT" ]]; then
    log_message "ERROR: Kernel signing script not found. Reinstalling kernel headers..."
    sudo apt install -y linux-headers-"$KERNEL_VERSION" || { log_message "ERROR: Failed to install kernel headers."; exit 1; }
fi
if [[ ! -f "$MOK_PRIV" ]] || [[ ! -f "$MOK_DER" ]]; then
    log_message "ERROR: MOK keys not found."
    exit 1
fi
sudo "$SIGN_SCRIPT" sha256 "$MOK_PRIV" "$MOK_DER" "$VMMON_PATH" || { log_message "ERROR: Failed to sign vmmon module."; exit 1; }
sudo "$SIGN_SCRIPT" sha256 "$MOK_PRIV" "$MOK_DER" "$VMNET_PATH" || { log_message "ERROR: Failed to sign vmnet module."; exit 1; }

# Verify module signatures
log_message "Verifying module signatures..."
if ! modinfo vmmon | grep -q "signature"; then
    log_message "ERROR: vmmon module signature invalid."
    exit 1
fi
if ! modinfo vmnet | grep -q "signature"; then
    log_message "ERROR: vmnet module signature invalid."
    exit 1
fi

# Reload modules
log_message "Reloading VMware modules..."
sudo modprobe -r vmmon vmnet 2>/dev/null || true
sudo modprobe vmmon || { log_message "ERROR: Failed to load vmmon module."; exit 1; }
sudo modprobe vmnet || { log_message "ERROR: Failed to load vmnet module."; exit 1; }

# Verify modules
log_message "Verifying module loading..."
if lsmod | grep -q "vmmon" && lsmod | grep -q "vmnet"; then
    log_message "VMware modules loaded successfully."
else
    log_message "ERROR: Failed to load VMware modules."
    exit 1
fi

log_message "VMware module signing completed successfully."
exit 0