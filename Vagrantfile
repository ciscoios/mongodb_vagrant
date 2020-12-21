Vagrant.configure("2") do |config|

#debian9
#  config.vm.box = "debian/stretch64"

#debian8
config.vm.box = "debian/jessie64"

  config.vm.hostname = "mongodb-test"
  config.vm.network :private_network, ip: "192.168.56.2", guest: 27017, host: 27017
  # config.vm.network "forwarded_port", guest: 27017, host: 27017
#   config.vm.network "forwarded_port", guest: 27017, host: 27018
  #  "forwarded_port", guest: 2003, host: 27017, protocol: "tcp"
 #config.vm.forward_port 27017, 27018

  # ssh settings
  config.ssh.insert_key = false
  config.ssh.private_key_path = ["keys/private/private.ppk", "~/.vagrant.d/insecure_private_key"]
#  config.vm.provision "file", source: "keys/public", destination: "~/.ssh/authorized_keys"
  config.vm.provision "shell", inline: <<-EOC
#    sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
    sudo service ssh restart
	#mkdir /vagrant-data
  EOC
 
#config.vm.synced_folder "data", "/vagrant-data", type: "nfs" 
 
#to change vm name in Virtualbox
   config.vm.provider "virtualbox" do |v|
  v.name = "mongodb-test"
end
config.vm.provision "shell",
    path: "mongodb_install.sh"
   end
