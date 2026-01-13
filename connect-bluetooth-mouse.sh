#!/usr/bin/env bash
# Logitech MX Master 2S Connection Helper

echo "═══════════════════════════════════════════"
echo "  Logitech MX Master 2S Connection Setup"
echo "═══════════════════════════════════════════"
echo ""
echo "Steps to put MX Master 2S in pairing mode:"
echo "1. Turn on the mouse (switch on bottom)"
echo "2. Press and hold the Easy-Switch button (channel 1, 2, or 3)"
echo "3. The LED should start blinking fast (pairing mode)"
echo ""
read -p "Press Enter when your MX Master 2S is blinking..."

# Start bluetoothctl
bluetoothctl << EOF
power on
agent on
default-agent
scan on
EOF

echo ""
echo "Scanning for devices (this will take 10 seconds)..."
echo "Look for your mouse name and MAC address (AA:BB:CC:DD:EE:FF)"
sleep 10

# Show discovered devices
echo ""
echo "Discovered devices:"
bluetoothctl devices

echo ""
read -p "Enter your mouse MAC address (e.g., AA:BB:CC:DD:EE:FF): " mac_address

if [[ -z "$mac_address" ]]; then
    echo "No MAC address provided. Exiting."
    exit 1
fi

# Connect to mouse
bluetoothctl << EOF
scan off
pair $mac_address
trust $mac_address
connect $mac_address
exit
EOF

echo ""
echo "Done! Your mouse should be connected."
echo "If it doesn't work, try running these manually:"
echo "  bluetoothctl"
echo "  connect $mac_address"
