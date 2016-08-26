# Node SerialPort Delays

This repository provides a Vagrantfile and two Node.js scripts to recreate a
slowdown observed in Node.js while making simultaneous network and IO requests.
The issue is documented on the [node-serialport issue tracker](https://github.com/EmergingTechnologyAdvisors/node-serialport/issues/797).

The gist of the issue: When using `node-serialport` while also issuing network
requests on networks using certain routers, the serial port will seem to become
unresponsive after just a few writes, corresponding to the number of `libuv`
threads in use.

The first script, `serial-test.js`, is designed to recreate a slowdown observed
when  using `node-serialport` while also making network requests on certain
routers. To exercise the serial port, we use an Arduino that simply reads one
character at a time from the serial port and writes it back to the serial port
immediately. Any serial loopback device should work.

However, the issue is not specific to node-serialport; it also occurs when
making calls to `fs`, the filesystem. Therefore, the second script,
`fs-test.js`, demonstrates the same issue using no serial devices.

The router we're using to reproduce the issue 100% of the time is a
NETGEAR WNR1000v4. Other routers can cause the issue, but so far this NETGEAR
reproduces it most reliably. To reiterate, though, this router in particular is
one of several (even high-end) routers on which we have seen the issue.

The Vagrant VM simulates a high-latency network, removing the need for a physical
router. It adds artificial latency to every port except port 22, the SSH port.
For details, see `configure.sh`.

Let's reproduce the issue!

## Installation

1. Clone this repo.
* Install [Vagrant](https://www.vagrantup.com/downloads.html)
* Install [VirtualBox](https://www.virtualbox.org/)
* Install the [VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads)
(for shared folders)
* In the root of this repo, run `vagrant up` to start the VM

## Hardware Setup

* No hardware is required to reproduce the issue using `fs-test.js`

* If you'd like to see the serial port behavior, connect your serial loopback
device of choice and run `serial-test.js`. The Vagrant VM comes pre-configured
to attach to any Arduino boards. If the serial device doesn't show up, you might
need to reconnect it, so VirtualBox can attach it to the VM. You can also
explicitly attach a serial device, including a non-Arduino, to the VM in the
VirtualBox settings.

## Reproducing the slowdown

The VM will come provisioned with [NVM](https://github.com/creationix/nvm), so
the first step is to select a version of Node. We reliably reproduce this bug
on multiple versions, but as a starting place, use 4.2.6.

1. Log into the VM with `vagrant ssh`
* Install Node with `nvm install 4.2.6`
* Move to the Vagrant shared folder with `cd /vagrant`
* Run a test with `node [test-name]`, where `[test-name]` is one of `fs-test` or
`serial-test`. We can simplify the test to use one thread in the `libuv`
threadpool to exasperate the issue, by invoking the test with
`UV_THREADPOOL_SIZE=1 node [test-name]`.

## Script Output

If the issue is being reproduced, the test script will be able to make one
network request per `libuv` thread before stalling. It will hang for at least 10
seconds (the latency added to the virtual machine's network interface) and then
continue.
