#!/bin/bash

# NetworkManager dispatcher script to run nsswitch scripts for WireGuard VPN
# Runs nsswitch_up.sh when wg0 is up, nsswitch_down.sh when wg0 is down

INTERFACE="$1"
ACTION="$2"
EXPECTED_INTERFACE="wg0"  # WireGuard interface name
UP_SCRIPT="/etc/nsswitch.d/nsswitch_up.sh"
DOWN_SCRIPT="/etc/nsswitch.d/nsswitch_down.sh"
LOG_FILE="/var/log/nsswitch_script.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Function to log messages
log_message() {
    local level="$1"
    local message="$2"
    echo "[$TIMESTAMP] [$level] $message" >> "$LOG_FILE"
}

# Debug: Log all received parameters
log_message "DEBUG" "Received: INTERFACE=$INTERFACE, ACTION=$ACTION"

# Skip if interface is not wg0
if [[ "$INTERFACE" != "$EXPECTED_INTERFACE" ]]; then
    log_message "INFO" "Interface $INTERFACE does not match $EXPECTED_INTERFACE. Skipping."
    exit 0
fi

# Skip dns-change events
if [[ "$ACTION" == "dns-change" ]]; then
    log_message "INFO" "Skipping dns-change event for INTERFACE=$INTERFACE"
    exit 0
fi

# Handle up/down actions
case "$ACTION" in
    up)
        if [[ -x "$UP_SCRIPT" ]]; then
            log_message "INFO" "Running $UP_SCRIPT for $EXPECTED_INTERFACE VPN up"
            sudo "$UP_SCRIPT"
            if [[ $? -eq 0 ]]; then
                log_message "INFO" "$UP_SCRIPT executed successfully"
            else
                log_message "ERROR" "$UP_SCRIPT failed with exit code $?"
            fi
        else
            log_message "ERROR" "$UP_SCRIPT not found or not executable"
        fi
        ;;
    down)
        if [[ -x "$DOWN_SCRIPT" ]]; then
            log_message "INFO" "Running $DOWN_SCRIPT for $EXPECTED_INTERFACE VPN down"
            sudo "$DOWN_SCRIPT"
            if [[ $? -eq 0 ]]; then
                log_message "INFO" "$DOWN_SCRIPT executed successfully"
            else
                log_message "ERROR" "$DOWN_SCRIPT failed with exit code $?"
            fi
        else
            log_message "ERROR" "$DOWN_SCRIPT not found or not executable"
        fi
        ;;
    *)
        log_message "INFO" "Unhandled action $ACTION for $EXPECTED_INTERFACE. Skipping."
        exit 0
        ;;
esac

exit 0