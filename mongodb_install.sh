#!/bin/bash

#install vim
sudo apt-get -y install vim && \

#add ssh-rsa key
#echo ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAp5k+1UT8DTb35qM7lXeuZcLs1NME0Zm9wAfioBoGSr1BUGvjMtq/A4tInLCfN+HI8Kx3HXlNIAJXaOjPc2EPPgwN2LMYR184HjCYydhTDb8UW3riORNL+3MjgAL5OgYNS9zsFtmn3utCT+B4Lo4itXyGNwLoFqy6zJ2XpKiow3GY/A3gPcBA8WGQUbiFcXqW2yM0Cac2gynhG1Vb8CdqYQNv95x3z9WSId3RIc5F1TYMa5kCxAh57Aaz3us/SmW3RZ4tQULXI2Wo8i6WydXNji44+I/BOPmwuGoeg4vzY25b4RLPcf/dTWywdRcTiGLEoU4WePrqfWPqP2SqQqNicQ== rsa-key-20180115 > /home/vagrant/.ssh/authorized_keys && \
#echo ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmq81JfPP+SWsvjcz9p4CbCuqZ9Z/zIhN+pyFemygXoZ7yLeYnjdPVjhzEQl/ha2+bzel+GxK3Y8KJRxrG1YBfrqAoN1jcAvXuKFekaLa1Rd++TDsRQYMHhZWOrgOYHoFpfZLyZoUHoRQCmVL5YHcfXGldu/HsR/l4+nPSTYqXfdJPQTGXkdGELxqoaJxxyr2mrzH9AI8eGQS9vdtpkiHXBLaFp4YJRTTHSe45iw+btGeknNGl355BdPAe+JSinhq/3DkdZwqCQ6tpemwc0ik4F4znmooDsmzsdfl4Cb8ccymEh1E/BdLs8jw7zmj+Kay6xuLU79cBOvB5e/Vub5Enw== rsa-key-20180116 > /home/vagrant/.ssh/authorized_keys && \
#cp id_rsa.pub > ~/.ssh/id_rsa

#Import key from the official MongoDB repository.
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \

#Issue the following command to create a list file for MongoDB.
echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \

#update the packages list
sudo apt-get update && \

#install the MongoDB package itself with the following command:
sudo apt-get install -y mongodb-org && \

#start the service, and ensure it starts when your server reboots:
sudo systemctl enable mongod.service && \
sudo systemctl start mongod && \

#check that the service has started properly
sudo systemctl status mongod | grep -i 'active(running)' |echo $? | if [ $? == 0 ]; \
then \
#to make possibility click save in non-interactive mode
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections &&  \
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections &&  \
#echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
#for ansible
#- name: prevent the iptables-peristent install dialog
#  debconf: name=iptables-persistent question={{ item }} vtype=boolean value=true
#  with_items:
#  - iptables-persistent/autosave_v4
#  - iptables-persistent/autosave_v6
#- name: install iptables-persistent
#  apt: name=iptables-persistent

sudo apt-get install -y iptables-persistent && \
#Next, remove any existing rules that may be in place, just in case:
sudo iptables -F && \
sudo iptables -P INPUT DROP && \
#sudo iptables -P FORWARD ACCEPT && \
#sudo iptables -P OUTPUT ACCEPT && \ 
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT && \
sudo iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT && \
sudo iptables -A INPUT -s 192.168.56.0/24 -p tcp -m tcp --dport 27017 -m state --state NEW,ESTABLISHED -j ACCEPT && \
sudo iptables -A INPUT -i lo -j ACCEPT && \
sudo iptables -A OUTPUT -d 192.168.56.2/32 -p tcp -m tcp --sport 27017 -m state --state ESTABLISHED -j ACCEPT && \
sudo iptables -A OUTPUT -o lo -j ACCEPT && \
#sudo netfilter-persistent save && \
#sudo iptables-save /etc/iptables.save && \
perl -pi -e 's/bindIp: 127.0.0.1/#bind_ip=127.0.0.1/g' /etc/mongod.conf \
; else exit 0; fi

