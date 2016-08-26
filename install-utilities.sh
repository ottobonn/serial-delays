#!/bin/sh
# Run as root user

# This script installs utilities useful for debugging the issue

echo "Installing utilities..."
sudo apt-get update

# Install network utilities
echo "Installing network utilities"
sudo apt-get install -y hping3 # for TCP ping measurement

# Install USB utils
echo "Installing USB utilities"
sudo apt-get install -y usbutils # for lsusb

# Install debugging tools
echo "Installing debugging utilities"
sudo apt-get install -y gdb
