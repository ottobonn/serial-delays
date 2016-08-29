#!/bin/bash

# Based on instructions from https://servidordebian.org/en/wheezy/intranet/dns/cache

# Install BIND9 and friends
sudo apt-get install -y bind9 dnsutils

# Configure BIND9 as a local DNS server
sudo cp ./etc-bind-named.conf.options /etc/bind/named.conf.options

# Configure resolv.conf manually for the current DHCP lease
sudo tee /etc/resolv.conf <<< "nameserver 127.0.0.1"

# Set up automatic resolv.conf reconfiguration on DHCP lease renewal
sudo cp ./etc-dhcp-dhclient.conf /etc/dhcp/dhclient.conf

# Restart BIND9 to load the new configuration
sudo service bind9 restart

# Restart our DHCP client
sudo service dhcpd restart
