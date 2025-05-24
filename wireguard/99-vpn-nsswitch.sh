#!/bin/bash

# NetworkManager dispatcher script to run nsswitch scripts for WireGuard VPN
# Runs nsswitch_up.sh when VPN is up, nsswitch_down.sh when VPN is down

INTERFACE="$1"
ACTION="$2"
CONNECTION_NAME="WireGuard"  # Exact VPN connection name
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

# Skip dns-change events
if [[ "$ACTION" == "dns-change" ]]; then
    log_message "INFO" "Skipping dns-change event for INTERFACE=$INTERFACE"
    exit 0
fi

# Get connection details for the interface
if [[ -n "$INTERFACE" ]]; then
    # Try active connections first
    CONNECTION=$(nmcli -t -f NAME,DEVICE connection show --active | grep ":$INTERFACE$" | cut -d: -f1)
    CONNECTION_UUID=$(nmcli -t -f UUID,DEVICE connection show --active | grep ":$INTERFACE$" | cut -d: -f1)
    log_message "DEBUG" "Active connections: $(nmcli -t -f NAME,DEVICE,UUID connection show --active)"
    log_message "DEBUG" "Found CONNECTION=$CONNECTION, UUID=$CONNECTION_UUID for INTERFACE=$INTERFACE (active)"

    # If no active connection found (e.g., during down), try all connections with delay
    if [[ -z "$CONNECTION" ]] && [[ "$ACTION" == "down" ]]; then
        sleep 1  # Delay to allow NetworkManager to update
        CONNECTION=$(nmcli -t -f NAME,connection.interface-name connection show | grep ":$INTERFACE$" | cut -d: -f1)
        CONNECTION_UUID=$(nmcli -t -f UUID,connection.interface-name connection show | grep ":$INTERFACE$" | cut -d: -f1)
        log_message "DEBUG" "All connections after delay: $(nmcli -t -f NAME,connection.interface-name,UUID connection show)"
        log_message "DEBUG" "Found CONNECTION=$CONNECTION, UUID=$CONNECTION_UUID for INTERFACE=$INTERFACE (all)"
    fi
else
    log_message "ERROR" "No INTERFACE provided"
    exit 1
fi

# Check if connection matches WireGuard
if [[ "$CONNECTION" != "$CONNECTION_NAME" ]]; then
    # Try matching by UUID
    if [[ -n "$CONNECTION_UUID" ]]; then
        CONN_NAME_BY_UUID=$(nmcli -t -f NAME,UUID connection show | grep ":$CONNECTION_UUID$" | cut -d: -f1)
        if [[ "$CONN_NAME_BY_UUID" == "$CONNECTION_NAME" ]]; then
            CONNECTION="$CONNECTION_NAME"
            log_message "DEBUG" "Matched $CONNECTION_NAME via UUID=$CONNECTION_UUID"
        else
            log_message "DEBUG" "UUID $CONNECTION_UUID does not match $CONNECTION_NAME (found $CONN_NAME_BY_UUID)"
        fi
    fi
fi

if [[ "$CONNECTION" != "$CONNECTION_NAME" ]]; then
    log_message "INFO" "Connection $CONNECTION (INTERFACE=$INTERFACE, ACTION=$ACTION) does not match $CONNECTION_NAME. Skipping."
    exit 0
fi

# Handle up/down actions
case "$ACTION" in
    up)
        if [[ -x "$UP_SCRIPT" ]]; then
            log_message "INFO" "Running $UP_SCRIPT for $CONNECTION_NAME VPN up on $INTERFACE"
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
            log_message "INFO" "Running $DOWN_SCRIPT for $CONNECTION_NAME VPN down on $INTERFACE"
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
        log_message "INFO" "Unhandled action $ACTION for $CONNECTION_NAME on $INTERFACE. Skipping."
        exit 0
        ;;
esac

exit 0