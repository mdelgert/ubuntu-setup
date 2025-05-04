#!/bin/bash

# Script to set up KVM and virt-manager on Ubuntu 24.04.2 LTS
# Run with: sudo bash kvm.sh

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting KVM setup for Ubuntu 24.04.2 LTS...${NC}"

# Step 1: Update system
echo -e "${GREEN}Updating system packages...${NC}"
apt update && apt upgrade -y

# Step 2: Check for virtualization support
echo -e "${GREEN}Checking CPU virtualization support...${NC}"
apt install -y cpu-checker
if kvm-ok; then
    echo -e "${GREEN}Virtualization support (VT-x/AMD-V) detected!${NC}"
else
    echo -e "${RED}Error: Virtualization not supported or disabled in BIOS.${NC}"
    echo -e "${YELLOW}Please enable VT-x (Intel) or AMD-V in BIOS and rerun the script.${NC}"
    exit 1
fi

# Step 3: Install KVM and virt-manager
echo -e "${GREEN}Installing KVM, virt-manager, and dependencies...${NC}"
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients virt-manager bridge-utils

# Step 4: Add user to libvirt and kvm groups
echo -e "${GREEN}Adding current user to libvirt and kvm groups...${NC}"
CURRENT_USER=$(whoami)
usermod -aG libvirt "$CURRENT_USER"
usermod -aG kvm "$CURRENT_USER"
echo -e "${YELLOW}You may need to log out and back in for group changes to take effect.${NC}"

# Step 5: Start and enable libvirt daemon
echo -e "${GREEN}Starting and enabling libvirt daemon...${NC}"
systemctl enable --now libvirtd
if systemctl is-active --quiet libvirtd; then
    echo -e "${GREEN}libvirt daemon is running.${NC}"
else
    echo -e "${RED}Error: libvirt daemon failed to start.${NC}"
    exit 1
fi

# Step 6: Verify KVM device
echo -e "${GREEN}Checking /dev/kvm permissions...${NC}"
if [ -e /dev/kvm ]; then
    ls -l /dev/kvm
    echo -e "${GREEN}/dev/kvm exists and is accessible.${NC}"
else
    echo -e "${RED}Error: /dev/kvm not found. KVM setup may have failed.${NC}"
    exit 1
fi

# Step 7: Check Wi-Fi (optional, since user mentioned Wi-Fi card)
echo -e "${GREEN}Checking Wi-Fi functionality...${NC}"
if nmcli device wifi list >/dev/null 2>&1; then
    echo -e "${GREEN}Wi-Fi appears to be working. VMs will use host's Wi-Fi via NAT.${NC}"
else
    echo -e "${YELLOW}Warning: Wi-Fi not detected. Installing common Wi-Fi drivers...${NC}"
    apt install -y firmware-b43-installer bcmwl-kernel-source
    echo -e "${YELLOW}Please reboot and check Wi-Fi with 'nmcli device wifi list'.${NC}"
fi

# Step 8: Verify virt-manager installation
echo -e "${GREEN}Verifying virt-manager...${NC}"
if command -v virt-manager >/dev/null 2>&1; then
    echo -e "${GREEN}virt-manager is installed.${NC}"
else
    echo -e "${RED}Error: virt-manager installation failed.${NC}"
    exit 1
fi

# Step 9: Final instructions
echo -e "${GREEN}KVM setup complete!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Log out and back in to apply group changes."
echo -e "2. Download a Windows ISO from https://www.microsoft.com/software-download."
echo -e "3. Open virt-manager (run 'virt-manager' or find it in the menu)."
echo -e "4. Create a new VM, select the Windows ISO, and allocate 2-4 CPU cores, 4-8GB RAM, 20-50GB storage."
echo -e "5. For better performance, download virtio drivers: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
echo -e "6. Need help? Check 'man virt-manager' or ask for further assistance."

exit 0