#!/bin/bash
#
# MOK (Machine Owner Key) Reset Script
# -----------------------------------
# This script resets all enrolled keys in the MOK (Machine Owner Key) list.
# Useful for:
#  - Resetting the MOK list completely
#  - Removing keys that are no longer needed
#  - Removing VMware module signing keys 
#  - Removing keys that were enrolled by Ventoy
#  - Removing keys that were enrolled by Veeam

# Check if mokutil is installed
if ! command -v mokutil &> /dev/null; then
    echo "mokutil is not installed."
    echo "This package is required for MOK management."
    read -p "Do you want to install it now? (y/n): " answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        echo "Installing mokutil..."
        sudo apt-get update
        sudo apt-get install -y mokutil
    else
        echo "Cannot continue without mokutil. Exiting."
        exit 1
    fi
fi

# Display message about what the script will do
echo "=========================================================================================================="
echo "This script will reset all MOK (Machine Owner Key) entries."
echo "You will need to reboot and follow several prompts to complete the process."
echo "Warning - This will remove all enrolled keys, including VMware module signing keys and any keys enrolled by Ventoy or Veeam."
echo "Please ensure you have the necessary keys backed up if needed."
echo "=========================================================================================================="
read -p "Press Enter to continue or Ctrl+C to cancel..."

# Optional: Show all currently enrolled keys
echo "Currently enrolled MOK keys:"
sudo mokutil --list-enrolled

# Reset all enrolled keys
echo "Resetting all MOK keys..."
sudo mokutil --reset

echo "====================================================="
echo "MOK reset initiated. Your system will now reboot."
echo "During the boot process:"
echo "1. Select 'Perform MOK management'"
echo "2. Select 'Reset MOK list'"
echo "3. Select 'Continue'"
echo "4. Select 'Yes' to confirm the reset"
echo "5. Enter the password you created when prompted"
echo "6. Select 'Reboot'"
echo "====================================================="
echo "After rebooting, verify the keys are gone by running:"
echo "sudo mokutil --list-enrolled"
echo ""
read -p "Press Enter to reboot now..."

# Reboot the system
sudo reboot
