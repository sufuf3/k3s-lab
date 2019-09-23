default_box = 'ubuntu/bionic64'

Vagrant.configure(2) do |config|
  config.vm.define 'master' do |master|
    master.vm.box = default_box
    master.vm.hostname = "master"
    master.vm.synced_folder ".", "/vagrant", type:"virtualbox"
    master.vm.network 'private_network', ip: "192.168.0.200",  virtualbox__intnet: true
    master.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: true
    master.vm.network "forwarded_port", guest: 22, host: 2000 # SSH TO MASTER/NODE
    master.vm.network "forwarded_port", guest: 6443, host: 6443 # ACCESS K8S API
    for p in 30000..30100 # PORTS DEFINED FOR K8S TYPE-NODE-PORT ACCESS
      master.vm.network "forwarded_port", guest: p, host: p, protocol: "tcp"
      end
    master.vm.provider "virtualbox" do |v|
      v.memory = "1024"
      v.name = "master"
      end

    master.vm.provision "shell", inline: <<-SHELL
      IPADDR=$(ip a show enp0s8 | grep "inet " | awk '{print $2}' | cut -d / -f1)
      hostnamectl set-hostname master
      sudo apt update
    SHELL
  end

  config.vm.define 'node1' do |node1|
    node1.vm.box = default_box
    node1.vm.hostname = "node1"
    node1.vm.synced_folder ".", "/vagrant", type:"virtualbox"
    node1.vm.network 'private_network', ip: "192.168.0.201",  virtualbox__intnet: true
    node1.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: true
    node1.vm.network "forwarded_port", guest: 22, host: 2001
    node1.vm.provider "virtualbox" do |v|
      v.memory = "1024"
      v.name = "node1"
      end

    node1.vm.provision "shell", inline: <<-SHELL
      IPADDR=$(ip a show enp0s8 | grep "inet " | awk '{print $2}' | cut -d / -f1)
    SHELL
  end

end
