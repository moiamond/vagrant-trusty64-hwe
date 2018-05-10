# -*- mode: ruby -*-
# vi: set ft=ruby :

# Require the reboot plugin.
require './vagrant-provision-reboot-plugin'

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get remove -y linux-image-generic linux-headers-generic linux-tools-generic
    apt-get update
    apt-get install -y linux-image-generic-lts-xenial linux-headers-generic-lts-xenial
  SHELL
      # Run a reboot of a *NIX guest.
  config.vm.provision :unix_reboot

  config.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
  end

end

