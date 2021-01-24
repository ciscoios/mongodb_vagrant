In this lab, I'll deploy apache-jmeter and run basic jmeter tests via vagrant.
You should install Virtualbox a Vagrant provider before you run the below commands.
The full list of Vagrant providers you can find here: 
https://www.vagrantup.com/docs/providers/
https://github.com/hashicorp/vagrant/wiki/Available-Vagrant-Plugins
I'll use Virtualbox provider in my lab.

To test this lab you just need to run the following command -
vagrant up

The result of the tests will be written into the result directory. There will be two files - first one in html format, the second one in csv format.

If needed, you can connect to newly created Vagrant virtual machine via ssh in the following way -

ssh vagrant@127.0.0.1 -p 2222

After testing you can stop virtual machine or destroy it.

To stop virtual machine run next command -
vagrant halt

To destroy virtual machine run this command -
vagrant destroy

P.S. I've tested it on Windows 10, Linux Mint 20.1 but I hope there will no issues with running this setup on other Linux distros and/or MacOS.
