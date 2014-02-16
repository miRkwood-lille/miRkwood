# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/playbook-mirkwood.yml"
    ansible.verbose = 'v'
  end
  config.vm.network :private_network, ip: "192.168.33.20"
  config.ssh.forward_x11 = true
end
    
