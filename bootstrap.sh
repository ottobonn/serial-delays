#!/bin/sh

# This script builds Node.js from source with debugging symbols

# Prepare build dependencies
echo "Installing dependencies"
sudo apt-get update
sudo apt-get install -y build-essential openssl libssl-dev pkg-config git linux-tools curl

# Get node source code
# cd /vagrant/
# mkdir node
# cd node
# wget https://github.com/nodejs/node/archive/v4.5.0.tar.gz
# tar -xvf v4.5.0.tar.gz

# Build node with debugging options
# cd node-4.5.0/
# ./configure --gdb --debug
# make -j 4
# make install
# cd ../..

# Get pre-built node with nvm
echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash


# Install network utilities
echo "Installing network utilities"
sudo apt-get install -y iproute hping3

# Install USB utils
echo "Installing USB utilities"
sudo apt-get install -y usbutils # socat

# Install debugging tools
echo "Installing debugging tools"
sudo apt-get install -y gdb linux-tools-3.16

# Give vagrant user serialport permissions
sudo usermod -aG dialout vagrant
