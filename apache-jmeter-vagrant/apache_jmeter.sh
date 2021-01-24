#!/bin/bash

sudo apt-get update
#sudo apt-get -qq -y install unzip openjdk-7-jdk
sudo apt-get -y install unzip openjdk-8-jdk

if [ ! -f /home/vagrant/apache-jmeter-5.2/bin/jmeter ];then
  cd /home/vagrant/
  wget -q http://apache.ip-connect.vn.ua//jmeter/binaries/apache-jmeter-5.2.zip
  unzip -q apache-jmeter-5.2.zip
  sudo chmod +x /home/vagrant/apache-jmeter-5.2/bin/jmeter.sh
fi
#Creating symbolic link to run jmeter without pointing full path

if [ ! -f /usr/sbin/jmeter ]; then
sudo ln -s /home/vagrant/apache-jmeter-5.2/bin/jmeter.sh /usr/sbin/jmeter
else 
exit 0
fi

if [ ! -d /vagrant/result ];then
  mkdir /vagrant/result
fi

#Some tests to test jmeter work in non-gui mode
sudo jmeter -n -t /home/vagrant/apache-jmeter-5.2/extras/Test.jmx -Jmeter.save.saveservice.output_format=html -l /vagrant/result/Test.html

sudo jmeter -n -t /home/vagrant/apache-jmeter-5.2/bin/examples/CSVSample.jmx -Jmeter.save.saveservice.output_format=csv -l /vagrant/result/CSVSample.csv