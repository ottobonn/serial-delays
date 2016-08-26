#!/bin/sh

# This script configures the network to simulate high latency for everything
# except port 22 (SSH)

echo "Configuring network delay with tc"

# Add root queueing discipline
sudo tc qdisc add dev eth0 handle 1: root htb
# Add top-level class to hold slow queue
sudo tc class add dev eth0 parent 1: classid 1:1 htb rate 100Mbps
# Add queue to class 1:1 for slowing traffic
sudo tc qdisc add dev eth0 parent 1:1 handle 10: netem delay 10000ms
# Add filter to route packets not from port 22 into the slow class
sudo tc filter add dev eth0 protocol ip parent 1: prio 1 basic match \
"cmp(u16 at 0 layer transport lt 22) or cmp(u16 at 0 layer transport gt 22)" \
flowid 1:1

# Note: to reset the interface to the default speed, run the following:
# sudo tc qdisc del dev eth0 root

# To change the delay on the network, use the following:
# sudo tc qdisc change dev eth0 handle 10: netem delay [new_delay]ms
