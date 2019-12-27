# -*- mode: ruby -*-
# vi: set ft=ruby :

# Require the reboot plugin.
require './vagrant-provision-reboot-plugin'

$VM_NAME = File.basename(Dir.getwd)

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.host_name = $VM_NAME
  
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

  config.vm.provision "shell", inline: <<-SHELL
    curl -sSL https://get.docker.com/ | sh
    usermod -aG docker vagrant
  SHELL
  
  config.vm.provision "shell", inline: <<-SHELL
    service docker stop

    pushd /etc/docker
    
cat <<EOF > daemon.json
{
  "insecure-registries" : ["registry.bss.moiamond.com:80"]
}
EOF

    popd

    service docker start
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    midir -p /home/jenkins-slave/workspace
    chmod -R 777 /home/jenkins-slave/workspace

    docker run -d --name jenkins-ci-slave \
        --restart always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /usr/bin/docker:/usr/bin/docker \
        -v /home/jenkins-slave/workspace:/home/jenkins-slave/workspace \
        moiamond/jenkins-ci-slave \
        -master http://jenkins.bss.moiamond.com \
        -name slave \
        -labels docker \
        -username swarm-slave \
        -password swarm-slave
  SHELL

  config.vm.provider "virtualbox" do |vb|
      vb.name = $VM_NAME
      vb.memory = "2048"
      vb.cpus = 2
  end

end

