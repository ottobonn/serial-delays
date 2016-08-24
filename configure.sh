#!/bin/sh

# This script configures the network to simulate high latency only for HTTP
# connections (port 80) so SSH stays snappy.

echo "Configuring network delay with tc"

#/home/vagrant/slow/slow --latency 100ms
# Add root queueing discipline
sudo tc qdisc add dev eth0 handle 1: root htb
# Add top-level class at 3Mbps, to be used for slowing traffic
sudo tc class add dev eth0 parent 1: classid 1:1 htb rate 0.1Mbps
# Add qdisc to class 1:1 for slowing traffic
sudo tc qdisc add dev eth0 parent 1:1 handle 10: netem delay 1000ms
# Add filter to route packets addressed to port 80 into class 1:1
sudo tc filter add dev eth0 protocol ip parent 1: prio 1 u32 match ip dport 80 0xFFFF flowid 1:1


# Note: to reset the interface to the default qdisc, run the following:
# sudo tc qdisc del dev eth0 root

# To change the delay on HTTP, use the following:
# sudo tc qdisc change dev eth0 handle 10: netem delay 5000ms

# Start socat virtual serial devices
# sudo socat -d -d pty,raw,echo=0,link=/dev/ttyS0 pty,raw,echo=0 &

# Test round-trip time on port 80:
# sudo hping3 -p 80 google.com


sudo modprobe ifb
sudo ip link set dev ifb0 up
sudo tc qdisc add dev ifb0 handle 1: root htb
sudo tc class add dev ifb0 parent 1: classid 1:1 htb rate 1Mbps
sudo tc qdisc add dev ifb0 parent 1:1 handle 10: netem delay 1000ms
sudo tc filter add dev ifb0 protocol ip parent 1: prio 1 u32 match ip sport 80 0xFFFF flowid 1:1
sudo tc qdisc add dev eth0 ingress

# Set up redirect from ifb0 to eth0
# sudo tc filter add dev ifb0 protocol ip parent 1: prio 1 u32 match ip sport 80 0xFFFF flowid 1:1 action mirred ingress redirect dev eth0

# Now redirect incoming port-80 packets from eth0 to ifb0 and back
# sudo tc filter add dev eth0 protocol ip parent 1: prio 1 u32 match ip sport 80 0xFFFF flowid 1:1 action mirred ingress redirect dev ifb0
