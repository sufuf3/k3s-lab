# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
NUM_NODE = 2
NODE_IP_NW = "192.168.26."
DISK_SIZE = "100" # 100MB
PRIVATE_KEY_PATH = "inventory/keys"
PRIVATE_KEY = "#{PRIVATE_KEY_PATH}/id_rsa"

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/xenial64"
  lab_env = ENV.fetch('LAB', true)

$hands_on = <<SHELL
set -e -x -u
echo "=== Setup Environment ==="
sudo apt-get update
SHELL


  (1..NUM_NODE).each do |i|
    config.vm.define "k3snode-#{i}" do |node|

      node.vm.hostname = "k3snode-#{i}"
      node_ip = NODE_IP_NW + "#{10 + i}"
      dpdk_ip = NODE_IP_NW + "#{15 + i}"
      node.vm.network :private_network, ip: node_ip
      node.vm.network "private_network", ip: dpdk_ip

     if lab_env == true
       config.vm.provision "shell", privileged: false, inline: $hands_on
     end

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
   config.vm.provider "virtualbox" do |v|
     # Display the VirtualBox GUI when booting the machine
      v.customize ["modifyvm", :id, "--cpus", 1]
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
      v.customize ["setextradata", :id, "VBoxInternal/CPUM/SSE4.1", "1"]
   end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
    end #node-i
  end #each node

end
