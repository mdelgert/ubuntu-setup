#!/bin/bash

# Script to set up KVM and virt-manager on Ubuntu 24.04.2 LTS
# Runs as regular user, escalating to sudo only for privileged operations
# https://www.dzombak.com/blog/2024/02/setting-up-kvm-virtual-machines-using-a-bridged-network/

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Define variables
LOG_FILE="$HOME/kvm-setup.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Function to log messages
log_message() {
    echo "$TIMESTAMP - $1" | tee -a "$LOG_FILE"
    echo -e "${2}${1}${NC}"
}

# Function to check if sudo is available
check_sudo() {
    if ! command -v sudo >/dev/null 2>&1; then
        log_message "ERROR: sudo is required but not installed." "$RED"
        exit 1
    fi
}

# Function to update system
update_system() {
    log_message "Updating system packages..." "$GREEN"
    sudo apt update || { log_message "ERROR: Failed to update package list." "$RED"; exit 1; }
    sudo apt upgrade -y || { log_message "ERROR: Failed to upgrade packages." "$RED"; exit 1; }
}

# Function to check virtualization support
check_virtualization() {
    log_message "Checking CPU virtualization support..." "$GREEN"
    sudo apt install -y cpu-checker || { log_message "ERROR: Failed to install cpu-checker." "$RED"; exit 1; }
    if kvm-ok; then
        log_message "Virtualization support (VT-x/AMD-V) detected!" "$GREEN"
    else
        log_message "Error: Virtualization not supported or disabled in BIOS." "$RED"
        log_message "Please enable VT-x (Intel) or AMD-V in BIOS and rerun the script." "$YELLOW"
        exit 1
    fi
}

# Function to install KVM and virt-manager
install_kvm_virtmanager() {
    log_message "Installing KVM, virt-manager, and dependencies..." "$GREEN"
    sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients virt-manager bridge-utils || {
        log_message "ERROR: Failed to install KVM and virt-manager packages." "$RED"
        exit 1
    }
}

# Function to add user to libvirt and kvm groups
add_user_to_groups() {
    log_message "Adding current user to libvirt and kvm groups..." "$GREEN"
    CURRENT_USER=$(whoami)
    sudo usermod -aG libvirt "$CURRENT_USER" || {
        log_message "ERROR: Failed to add user to libvirt group." "$RED"
        exit 1
    }
    sudo usermod -aG kvm "$CURRENT_USER" || {
        log_message "ERROR: Failed to add user to kvm group." "$RED"
        exit 1
    }
    log_message "You may need to log out and back in for group changes to take effect." "$YELLOW"
}

# Function to start and enable libvirt daemon
manage_libvirt_daemon() {
    log_message "Starting and enabling libvirt daemon..." "$GREEN"
    sudo systemctl enable --now libvirtd || {
        log_message "ERROR: Failed to enable libvirt daemon." "$RED"
        exit 1
    }
    if systemctl is-active --quiet libvirtd; then
        log_message "libvirt daemon is running." "$GREEN"
    else
        log_message "Error: libvirt daemon failed to start." "$RED"
        exit 1
    fi
}

# Function to verify KVM device
verify_kvm_device() {
    log_message "Checking /dev/kvm permissions..." "$GREEN"
    if [ -e /dev/kvm ]; then
        ls -l /dev/kvm
        log_message "/dev/kvm exists and is accessible." "$GREEN"
    else
        log_message "Error: /dev/kvm not found. KVM setup may have failed." "$RED"
        exit 1
    fi
}

# Function to check Wi-Fi
check_wifi() {
    log_message "Checking Wi-Fi functionality..." "$GREEN"
    if nmcli device wifi list >/dev/null 2>&1; then
        log_message "Wi-Fi appears to be working. VMs will use host's Wi-Fi via NAT." "$GREEN"
    else
        log_message "Warning: Wi-Fi not detected. Installing common Wi-Fi drivers..." "$YELLOW"
        sudo apt install -y firmware-b43-installer bcmwl-kernel-source || {
            log_message "ERROR: Failed to install Wi-Fi drivers." "$RED"
            exit 1
        }
        log_message "Please reboot and check Wi-Fi with 'nmcli device wifi list'." "$YELLOW"
    fi
}

# Function to verify virt-manager installation
verify_virt_manager() {
    log_message "Verifying virt-manager..." "$GREEN"
    if command -v virt-manager >/dev/null 2>&1; then
        log_message "virt-manager is installed." "$GREEN"
    else
        log_message "Error: virt-manager installation failed." "$RED"
        exit 1
    fi
}

# Function to display final instructions
display_instructions() {
    log_message "KVM setup complete!" "$GREEN"
    log_message "Next steps:" "$YELLOW"
    echo -e "${YELLOW}1. Log out and back in to apply group changes.${NC}"
    echo -e "${YELLOW}2. Download a Windows ISO from https://www.microsoft.com/software-download.${NC}"
    echo -e "${YELLOW}3. Open virt-manager (run 'virt-manager' or find it in the menu).${NC}"
    echo -e "${YELLOW}4. Create a new VM, select the Windows ISO, and allocate 2-4 CPU cores, 4-8GB RAM, 20-50GB storage.${NC}"
    echo -e "${YELLOW}5. For better performance, download virtio drivers: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso${NC}"
    echo -e "${YELLOW}6. Need help? Check 'man virt-manager' or ask for further assistance.${NC}"
}

# Main execution
log_message "Starting KVM setup for Ubuntu 24.04.2 LTS..." "$YELLOW"

# Check if sudo is available
check_sudo

# Perform setup steps
update_system
check_virtualization
install_kvm_virtmanager
add_user_to_groups
manage_libvirt_daemon
verify_kvm_device
check_wifi
verify_virt_manager
display_instructions

log_message "KVM and virt-manager setup completed successfully." "$GREEN"
exit 0