#!/bin/bash

# Script to install VMware Workstation on Ubuntu
# Runs as regular user, escalating to sudo only for privileged operations
# https://phoenixnap.com/kb/install-vmware-workstation-ubuntu
# https://knowledge.broadcom.com/external/article/315653/supported-host-operating-systems-for-wor.html
# https://www.linuxtechi.com/install-vmware-workstation-on-ubuntu/

# Exit on any error
set -e

# Uninstall VMware Workstation if needed
#sudo vmware-installer -u vmware-workstation

# Define variables
VMWARE_INSTALLER="/mnt/d1/apps/VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle"

LOG_FILE="$HOME/vmware-installation.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
REQUIRED_PACKAGES=("gcc-12" "libgcc-12-dev" "build-essential")

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

# Function to validate installer file
validate_installer() {
    log_message "Validating VMware installer..."
    if [[ ! -f "$VMWARE_INSTALLER" ]]; then
        log_message "ERROR: Installer file not found at $VMWARE_INSTALLER"
        exit 1
    fi
    if [[ ! "$VMWARE_INSTALLER" =~ \.bundle$ ]]; then
        log_message "ERROR: Invalid installer file. Must be a .bundle file."
        exit 1
    fi
    log_message "Installer validated successfully."
}

# Function to set executable permissions
set_permissions() {
    log_message "Setting executable permissions on installer..."
    chmod +x "$VMWARE_INSTALLER" || {
        log_message "ERROR: Failed to set executable permissions on $VMWARE_INSTALLER"
        exit 1
    }
    log_message "Permissions set successfully."
}

# Function to install required packages
install_packages() {
    log_message "Installing required packages..."
    sudo apt update || {
        log_message "ERROR: Failed to update package list."
        exit 1
    }
    for package in "${REQUIRED_PACKAGES[@]}"; do
        if ! dpkg -s "$package" >/dev/null 2>&1; then
            sudo apt install -y "$package" || {
                log_message "ERROR: Failed to install $package."
                exit 1
            }
        else
            log_message "$package is already installed."
        fi
    done
    log_message "Required packages installed successfully."
}

# Function to run VMware installer
run_installer() {
    log_message "Running VMware Workstation installer..."
    if ! sudo "$VMWARE_INSTALLER"; then
        log_message "ERROR: VMware installation failed."
        exit 1
    fi
    log_message "VMware Workstation installed successfully."
}

# Function to verify installation
verify_installation() {
    log_message "Verifying VMware Workstation installation..."
    if command -v vmware >/dev/null 2>&1; then
        log_message "VMware Workstation is installed and accessible."
    else
        log_message "ERROR: VMware Workstation installation could not be verified."
        exit 1
    fi
}

# Main execution
log_message "Starting VMware Workstation installation process..."

# Check if sudo is available
check_sudo

# Perform installation steps
validate_installer
set_permissions
install_packages
run_installer
verify_installation

log_message "VMware Workstation installation completed successfully."
exit 0