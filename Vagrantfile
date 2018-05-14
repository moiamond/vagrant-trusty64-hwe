# -*- mode: ruby -*-
# vi: set ft=ruby :

# Require the reboot plugin.
require './vagrant-provision-reboot-plugin'

$VM_NAME = "vc-lab"

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.host_name = $VM_NAME
  
  config.vm.synced_folder "..", "/code"

  config.vm.network "public_network"
  
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
    # install basic dev tools
    apt-get update
    
    apt-get -y install \
        iproute2 \
        net-tools \
        vim \
        git \
        tmux \
        autoconf \
        automake \
        libtool \
        g++ \
        wget \
        uuid-dev \
        dbus \
        diffstat \
        texinfo \
        gawk \
        chrpath \
        fakeroot \
        u-boot-tools \
        valgrind \
        intltool \
        libc6-i386 \
        psmisc \
        software-properties-common \
        cmake \
        pkg-config

    apt-get -y install \
        build-essential \
        libass-dev \
        libfreetype6-dev \
        libsdl1.2-dev \
        libtheora-dev \
        libtool \
        libva-dev \
        libvdpau-dev \
        libvorbis-dev \
        libxcb1-dev \
        libxcb-shm0-dev \
        libxcb-xfixes0-dev \
        libx264-dev \
        libvpx-dev \
        libopus-dev \
        libgsm1-dev \
        libfaac-dev \
        libgstreamer-plugins-bad1.0-dev \
        libspeexdsp-dev \
        texinfo \
        zlib1g-dev \
        yasm \
        tar
  SHELL
  # Build libfreetype2
  config.vm.provision "shell", inline: <<-SHELL
    wget http://download.savannah.gnu.org/releases/freetype/freetype-2.4.12.tar.bz2
    tar -xvjf freetype-2.4.12.tar.bz2
    cd freetype-2.4.12
    ./configure
    make
    make install
  SHELL
  # build ffmpeg
  config.vm.provision "shell", inline: <<-SHELL
    git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg
    cd ffmpeg
    git checkout n1.2

    ./configure --extra-cflags="-fPIC" --extra-ldflags="-lpthread" --enable-pic --enable-memalign-hack --enable-pthreads --enable-shared --disable-static --disable-network --enable-pthreads --disable-ffmpeg --disable-ffplay --disable-ffserver --disable-ffprobe --enable-gpl --disable-debug --enable-libfreetype --enable-libfaac --enable-nonfree
    make
    make install
  SHELL

  config.vm.provider "virtualbox" do |vb|
      vb.name = $VM_NAME
        vb.cpus = 2
  end

end

