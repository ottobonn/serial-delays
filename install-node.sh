#!/bin/sh
# Run without root permissions
# Get pre-built node with nvm
echo "Installing nvm"
sudo apt-get install -y curl
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash
export NVM_DIR="/home/vagrant/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install 4.5.0

# Uncomment the below to build Node from source, for debugging symbols useful in
# GDB.

# sudo apt-get install -y build-essential openssl libssl-dev pkg-config git linux-tools curl
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
