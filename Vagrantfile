Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/hirsute64"
  config.vm.hostname = "mongodb-lab"
  #config.vm.network :private_network, ip: "192.168.56.2", guest: 27017, host: 27017
  #config.vm.network "forwarded_port",  host_ip: "127.0.0.1", guest: 27017, host: 27017
config.vm.network "forwarded_port", host_ip: "127.0.0.1", guest_ip: "127.0.0.1", guest: 27017, host: 27017,
    auto_correct: true

#to change vm name in Virtualbox
   config.vm.provider "virtualbox" do |v|
 # Do not display the VirtualBox GUI when booting the machine
  v.gui = false
  v.name = "mongodb-lab"
  # Customize the amount of memory on the VM:
  v.memory = 2048

end
config.vm.provision "shell",
    path: "mongodb_install.sh"
   end
