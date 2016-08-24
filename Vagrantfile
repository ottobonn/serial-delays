# -*- mode: ruby -*-
# vi: set ft=ruby :

unless Vagrant.has_plugin?("vagrant-vbguest")
  raise 'Please install vagrant-vbguest to enable USB and VirtualBox shared folders.'
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.provision :shell, path: "configure.sh", run: "always"

  config.vm.box = "debian/jessie64"

  config.vm.synced_folder ".", "/vagrant/", type: "virtualbox"

  config.vm.provider "virtualbox" do |vb|
    # Increase RAM limit for linking node
    vb.customize ["modifyvm", :id, "--memory", "1024"]

    # Allow USB devices
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "on"]

    # Attach Arduinos to VB
    vb.customize ["usbfilter", "add", "0",
        "--target", :id,
        "--name", "Any Arduino",
        "--manufacturer", "Arduino LLC"]

  end

end
