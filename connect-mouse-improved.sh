#!/usr/bin/env bash
# Improved Bluetooth Mouse Connection Script

MAC="FF:87:8A:06:6D:F0"

echo "═══════════════════════════════════════════"
echo "  Connecting to MX Master 2S"
echo "  MAC: $MAC"
echo "═══════════════════════════════════════════"
echo ""
echo "Make sure your mouse is in pairing mode (LED blinking)"
read -p "Press Enter when ready..."

# Use expect-like approach with timeout
(
  echo "power on"
  sleep 1
  echo "agent on"
  sleep 1
  echo "default-agent"
  sleep 1
  echo "scan on"
  sleep 15
  echo "scan off"
  sleep 1
  echo "pair $MAC"
  sleep 3
  echo "trust $MAC"
  sleep 1
  echo "connect $MAC"
  sleep 2
  echo "exit"
) | bluetoothctl

echo ""
echo "Connection attempt complete!"
echo ""
echo "To verify connection:"
echo "  bluetoothctl info $MAC"
