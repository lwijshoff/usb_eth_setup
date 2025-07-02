#!/bin/bash

# This script sets up the USB Ethernet adapter configuration on a new Ubuntu system
# It will copy the user's local .rules and .service files, install necessary packages, and reload configurations

# Define file paths
LOCAL_UDEV_RULES="10-local-net.rules"
LOCAL_SYSTEMD_SERVICE="eth_startup.service"

# Define target paths
UDEV_RULES_PATH="/etc/udev/rules.d/10-local-net.rules"
SYSTEMD_SERVICE_PATH="/etc/systemd/system/eth_startup.service"

# Check for root user (required for the script to run)
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)."
    exit 1
fi

# Ensure the local files exist
if [[ ! -f "$LOCAL_UDEV_RULES" ]]; then
    echo "Error: Local udev rule file not found at $LOCAL_UDEV_RULES"
    exit 1
fi

if [[ ! -f "$LOCAL_SYSTEMD_SERVICE" ]]; then
    echo "Error: Local systemd service file not found at $LOCAL_SYSTEMD_SERVICE"
    exit 1
fi

# Copy udev rule to the appropriate location
echo "Copying udev rule to $UDEV_RULES_PATH..."
cp "$LOCAL_UDEV_RULES" "$UDEV_RULES_PATH"
chmod 644 "$UDEV_RULES_PATH"
echo "Udev rule copied successfully."

# Copy systemd service to the appropriate location
echo "Copying systemd service to $SYSTEMD_SERVICE_PATH..."
cp "$LOCAL_SYSTEMD_SERVICE" "$SYSTEMD_SERVICE_PATH"
chmod 644 "$SYSTEMD_SERVICE_PATH"
echo "Systemd service copied successfully."

# Install necessary dependencies (if not already installed)
echo "Checking and installing required dependencies..."

# Update package list and install necessary packages
apt update
apt install -y dhclient systemd

# Reload udev and systemd configurations
echo "Reloading udev rules and systemd..."
udevadm control --reload
systemctl daemon-reload

# Enable the systemd service to start at boot
systemctl enable eth_startup.service
echo "eth_startup.service enabled to run at boot."

# Start the systemd service to ensure it works immediately
systemctl start eth_startup.service
echo "Systemd service started successfully."

# Final message
echo "USB Ethernet adapter setup complete! Your adapter should now automatically be brought up and receive an IP address on boot."