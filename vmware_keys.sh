#!/bin/bash

# Script to sign VMware kernel modules (vmmon, vmnet) for Secure Boot on Ubuntu
# Runs as regular user, escalating to sudo only for privileged operations
# https://github.com/mdelgert/ReferenceNotes/blob/main/VMWARE/VMWARE_SECURE_BOOT.md

# Exit on any error
set -e

# Define variables
KEY_DIR="$HOME/vmware-keys"
MOK_PRIV="$KEY_DIR/MOK.priv"
MOK_DER="$KEY_DIR/MOK.der"
LOG_FILE="$HOME/vmware-module-signing.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
KERNEL_VERSION=$(uname -r)

# Function to log messages
log_message() {
    echo "$TIMESTAMP - $1" | tee -a "$LOG_FILE"
}

# Function to check if sudo is available
check_sudo() {
    if ! command -v sudo >/dev/null 2>&1; then
        log_message "ERROR: sudo is required but not installed."
        exit 1
    fi
}

# Function to check Secure Boot status
check_secure_boot() {
    log_message "Checking Secure Boot status..."
    if ! command -v mokutil >/dev/null 2>&1; then
        log_message "ERROR: mokutil not installed. Run with --install to install required packages."
        exit 1
    fi
    if mokutil --sb-state | grep -q "SecureBoot enabled"; then
        log_message "Secure Boot is enabled. Proceeding with module signing."
    else
        log_message "Secure Boot is disabled. No signing required."
        exit 0
    fi
}

# Function to install required packages
install_packages() {
    log_message "Installing required packages..."
    sudo apt update || { log_message "ERROR: Failed to update package list."; exit 1; }
    sudo apt install -y mokutil openssl linux-headers-"$KERNEL_VERSION" || {
        log_message "ERROR: Failed to install packages (mokutil, openssl, linux-headers-$KERNEL_VERSION)."
        exit 1
    }
    log_message "Packages installed successfully."
}

# Function to generate signing key
generate_key() {
    log_message "Generating signing key..."
    mkdir -p "$KEY_DIR" || { log_message "ERROR: Failed to create key directory."; exit 1; }
    cd "$KEY_DIR" || { log_message "ERROR: Failed to change to key directory."; exit 1; }
    if [[ -f "$MOK_PRIV" ]] || [[ -f "$MOK_DER" ]]; then
        read -p "Keys already exist in $KEY_DIR. Overwrite? (y/N): " choice
        if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
            log_message "Aborted by user."
            exit 1
        fi
    fi
    openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der \
        -nodes -days 36500 -subj "/CN=VMware Module Signing/" || {
        log_message "ERROR: Failed to generate signing key."
        exit 1
    }
    log_message "Signing key generated successfully."
}

# Function to enroll MOK key
enroll_key() {
    log_message "Enrolling MOK key..."
    if [[ ! -f "$MOK_DER" ]]; then
        log_message "ERROR: MOK.der not found in $KEY_DIR. Run with --generate first."
        exit 1
    fi
    if mokutil --list-enrolled | grep -q "VMware"; then
        log_message "MOK key already enrolled. Skipping enrollment."
        return
    fi
    if ! sudo mokutil --import "$MOK_DER"; then
        log_message "ERROR: Failed to import MOK key."
        exit 1
    fi
    log_message "MOK key imported. Please set a password when prompted."
    echo "WARNING: You must reboot and enroll the key in the MOK manager."
    echo "Steps during reboot:"
    echo "1. Select 'Enroll MOK'"
    echo "2. Select 'Continue'"
    echo "3. Select 'Yes'"
    echo "4. Enter the password you set"
    read -p "Reboot now to enroll key? (y/N): " reboot_choice
    if [[ "$reboot_choice" == "y" || "$reboot_choice" == "Y" ]]; then
        log_message "Initiating reboot for MOK enrollment."
        sudo reboot
    else
        log_message "Please reboot manually to complete MOK enrollment, then rerun the script with --all."
        exit 0
    fi
}

# Function to verify MOK enrollment
verify_mok() {
    log_message "Verifying MOK enrollment..."
    if mokutil --list-enrolled | grep -q "VMware"; then
        log_message "MOK key successfully enrolled."
    else
        log_message "ERROR: MOK key not enrolled."
        exit 1
    fi
}

# Function to check VMware installation
check_vmware_modules() {
    log_message "Checking for VMware modules..."
    if ! modinfo vmmon >/dev/null 2>&1; then
        log_message "ERROR: vmmon module not found. Ensure VMware Workstation is installed."
        exit 1
    fi
    if ! modinfo vmnet >/dev/null 2>&1; then
        log_message "ERROR: vmnet module not found. Ensure VMware Workstation is installed."
        exit 1
    fi
    log_message "VMware modules (vmmon, vmnet) found."
}

# Function to sign VMware modules
sign_modules() {
    log_message "Signing VMware modules..."
    VMMON_PATH=$(modinfo -n vmmon 2>/dev/null) || { log_message "ERROR: vmmon module not found."; exit 1; }
    VMNET_PATH=$(modinfo -n vmnet 2>/dev/null) || { log_message "ERROR: vmnet module not found."; exit 1; }
    SIGN_SCRIPT="/usr/src/linux-headers-$KERNEL_VERSION/scripts/sign-file"
    if [[ ! -f "$SIGN_SCRIPT" ]]; then
        log_message "ERROR: Kernel signing script not found at $SIGN_SCRIPT. Installing kernel headers..."
        sudo apt install -y linux-headers-"$KERNEL_VERSION" || {
            log_message "ERROR: Failed to install linux-headers-$KERNEL_VERSION."
            exit 1
        }
    fi
    if [[ ! -f "$MOK_PRIV" ]] || [[ -f "$MOK_DER" ]]; then
        log_message "ERROR: Signing keys not found in $KEY_DIR. Run with --generate first."
        exit 1
    fi
    if [[ ! -f "$VMMON_PATH" ]]; then
        log_message "ERROR: vmmon module file not found at $VMMON_PATH."
        exit 1
    fi
    if [[ ! -f "$VMNET_PATH" ]]; then
        log_message "ERROR: vmnet module file not found at $VMNET_PATH."
        exit 1
    fi
    sudo "$SIGN_SCRIPT" sha256 "$MOK_PRIV" "$MOK_DER" "$VMMON_PATH" || {
        log_message "ERROR: Failed to sign vmmon module. Check permissions and module integrity."
        exit 1
    }
    sudo "$SIGN_SCRIPT" sha256 "$MOK_PRIV" "$MOK_DER" "$VMNET_PATH" || {
        log_message "ERROR: Failed to sign vmnet module. Check permissions and module integrity."
        exit 1
    }
    log_message "Modules signed successfully."
}

# Function to reload modules
reload_modules() {
    log_message "Reloading VMware modules..."
    sudo modprobe -r vmmon vmnet 2>/dev/null || true
    sudo modprobe vmmon || { log_message "ERROR: Failed to load vmmon module."; exit 1; }
    sudo modprobe vmnet || { log_message "ERROR: Failed to load vmnet module."; exit 1; }
    log_message "Modules reloaded successfully."
}

# Function to verify module loading
verify_modules() {
    log_message "Verifying module loading..."
    if lsmod | grep -q "vmmon"; then
        log_message "vmmon module loaded successfully."
    else
        log_message "ERROR: vmmon module not loaded."
        exit 1
    fi
    if lsmod | grep -q "vmnet"; then
        log_message "vmnet module loaded successfully."
    else
        log_message "ERROR: vmnet module not loaded."
        exit 1
    fi
}

# Function to run all steps
run_all() {
    log_message "Running all steps for VMware module signing..."
    check_secure_boot
    install_packages
    generate_key
    enroll_key
    # If enroll_key triggers a reboot, the script exits here
    verify_mok
    check_vmware_modules
    sign_modules
    reload_modules
    verify_modules
    log_message "All steps completed successfully."
}

# Main execution
log_message "Starting VMware module signing process..."

# Check if sudo is available
check_sudo

# Handle different stages
case "$1" in
    --check)
        check_secure_boot
        ;;
    --install)
        install_packages
        ;;
    --generate)
        generate_key
        ;;
    --enroll)
        enroll_key
        ;;
    --verify-mok)
        verify_mok
        ;;
    --sign)
        check_vmware_modules
        sign_modules
        reload_modules
        verify_modules
        ;;
    --all)
        run_all
        ;;
    *)
        log_message "Usage: $0 [--check | --install | --generate | --enroll | --verify-mok | --sign | --all]"
        echo "Options:"
        echo "  --check      Check Secure Boot status"
        echo "  --install    Install required packages"
        echo "  --generate   Generate signing key"
        echo "  --enroll     Enroll MOK key (requires reboot)"
        echo "  --verify-mok Verify MOK key enrollment"
        echo "  --sign       Sign and reload VMware modules"
        echo "  --all        Run all steps in sequence (may require reboot)"
        exit 1
        ;;
esac

log_message "Operation completed successfully."
exit 0