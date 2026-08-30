#!/bin/bash
set -e

LOCAL_UDEV_RULES="10-local-net.rules"
LOCAL_SYSTEMD_SERVICE="eth_startup@.service"

UDEV_RULES_PATH="/etc/udev/rules.d/10-local-net.rules"
SYSTEMD_SERVICE_PATH="/etc/systemd/system/eth_startup@.service"

if [[ $EUID -ne 0 ]]; then
    echo "Error: Must be run as root." >&2
    exit 1
fi

echo "Copying udev rule to $UDEV_RULES_PATH..."
cp "$LOCAL_UDEV_RULES" "$UDEV_RULES_PATH"
chmod 644 "$UDEV_RULES_PATH"

echo "Copying systemd service template to $SYSTEMD_SERVICE_PATH..."
cp "$LOCAL_SYSTEMD_SERVICE" "$SYSTEMD_SERVICE_PATH"
chmod 644 "$SYSTEMD_SERVICE_PATH"

echo "Installing dependencies..."
apt update && apt install -y isc-dhcp-client net-tools

echo "Reloading subsystem configurations..."
udevadm control --reload-rules
udevadm trigger --subsystem-match=net
systemctl daemon-reload

echo "Universal USB Ethernet setup complete! Any USB adapter will now automatically configure on insertion."
