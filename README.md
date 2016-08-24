# Node SerialPort Delays

This repository provides a Vagrantfile and a Node.js script to recreate a
slowdown observed when using `node-serialport` while also making network
requests on certain routers.

Using the specified Vagrant box and a suitable router should allow the
reproduction of the [issue](https://github.com/EmergingTechnologyAdvisors/node-serialport/issues/797)
opened on node-serialport's repo.

The gist of the issue: When using node-serialport while also issuing network
requests on networks using certain routers, the serial port will seem to become
unresponsive after just a few writes, corresponding to the number of libuv
threads in use.

To exercise the serial port, we use an Arduino that simply reads one character
at a time from the serial port and writes it back to the serial port
immediately. Any serial loopback device should work, including a
software-defined one, though I have not yet been able to set up a software
solution.

The router we're using to reproduce the issue 100% of the time is a
NETGEAR WNR1000v4. Other routers can cause the issue, but so far this NETGEAR
reproduces it most reliably. To reiterate, though, this router in particular is
one of several (even high-end) routers on which we have seen the issue.

Let's reproduce the issue!

## Installation

1. Clone this repo.
* Install [Vagrant](https://www.vagrantup.com/downloads.html)
* Install [VirtualBox](https://www.virtualbox.org/)
* Install the [VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads)
(for USB peripheral support)
* In the root of this repo, run `vagrant up` to start the VM

## Hardware Setup

1. Connect the NETGEAR or other suitable router to the Internet, and connect
your computer of choice to the router over Ethernet or WiFi
* Connect a suitable serial loopback device over USB.

## Reproducing the slowdown

The VM will come provisioned with [NVM](https://github.com/creationix/nvm), so
the first step is to select a version of Node. We reliably reproduce this bug
on multiple versions, but as a starting place, use 4.2.6.

1. Log into the VM with `vagrant ssh`
* Install Node with `nvm install 4.2.6`
* Move to the Vagrant shared folder with `cd /vagrant`
* Run the test with `node test`

If the serial device doesn't show up, you might need to reconnect it, so
VirtualBox can attach it to the VM. You can also explicitly attach a serial
device to the VM in the VirtualBox settings.

## Expected Output

The test script should be able make four network requests before stalling. The
output to the console should look exactly like this if the system is
reproducing the issue:

    port name: /dev/ttyACM0
    Port open
    write: A
    on data: A
    write: A
    make request 0
    on data: A
    write: A
    make request 1
    on data: A
    write: A
    make request 2
    on data: A
    write: A
    make request 3
    tick 0
    tick 1
    tick 2
    tick 3
    tick 4
    tick 5
    tick 6
    tick 7
    tick 8
    tick 9
    tick 10
    tick 11
    tick 12
    tick 13
    on data: A
    write: A
    make request 4

Notice that, although the network requests are relatively small and the serial
device responds instantly, 13 seconds elapse between the fourth request and the
next serial data received.

The delay does not vary; it always corresponds to 13 "ticks."
