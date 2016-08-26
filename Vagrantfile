# -*- mode: ruby -*-
# vi: set ft=ruby :

unless Vagrant.has_plugin?("vagrant-vbguest")
  raise 'Please install vagrant-vbguest to enable USB and VirtualBox shared folders.'
end

Vagrant.configure("2") do |config|

  config.vm.box = "debian/jessie64"

  config.vm.synced_folder ".", "/vagrant/", type: "virtualbox"

  config.vm.provision "shell", path: "install-utilities.sh"

  # Give vagrant user serial port permissions
  config.vm.provision "shell", inline: "sudo usermod -aG dialout vagrant"

  config.vm.provision "shell", path: "install-node.sh", privileged: false

  config.vm.provision "shell", path: "simulate-latency.sh", run: "always"

  config.vm.provider "virtualbox" do |vb|
    # Make the VM name more descriptive
    vb.name = "serial-delays Testing Environment"

    # Increase RAM limit for linking node
    vb.customize ["modifyvm", :id, "--memory", "1024"]

    # Allow USB devices
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "on"]

    # Attach Arduinos to the VM
    vb.customize ["usbfilter", "add", "0",
        "--target", :id,
        "--name", "Any Arduino",
        "--manufacturer", "Arduino LLC"]

  end

end
