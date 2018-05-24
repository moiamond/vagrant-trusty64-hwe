# -*- mode: ruby -*-
# vi: set ft=ruby :

# Require the reboot plugin.
require './vagrant-provision-reboot-plugin'

$VM_NAME = "docker-lab"

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.host_name = $VM_NAME
  
  config.vm.synced_folder "..", "/code"

  config.vm.network "private_network", type: "dhcp"

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
  end

  config.vm.provision "shell", inline: <<-SHELL
    curl -sSL https://get.docker.com/ | sh
    usermod -aG docker vagrant
  SHELL
  
  # Run a reboot of a *NIX guest.
  config.vm.provision :unix_reboot

  config.vm.provider "virtualbox" do |vb|
    vb.name = $VM_NAME
    vb.memory = "2048"
    vb.cpus = 2

    # change the network card hardware for better performance
    vb.customize ["modifyvm", :id, "--nictype1", "virtio" ]
    vb.customize ["modifyvm", :id, "--nictype2", "virtio" ]

    # suggested fix for slow network performance
    # see https://github.com/mitchellh/vagrant/issues/1807
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]

    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
  end

end

