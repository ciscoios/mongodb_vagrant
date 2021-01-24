#!/bin/bash

#Install gpg key
sudo apt-get install -y gnupg 

#Import the public key used by the package management system
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/mongodb.gpg --import

#Setup read/write permissions to our newly created gpg key
sudo chmod 644 /etc/apt/trusted.gpg.d/mongodb.gpg


#Create a list file for MongoDB
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

#Reload local package database.
sudo apt-get update

#Install mongodb
sudo apt-get install -y mongodb-org

#Start mongodb
sudo systemctl start mongod || sudo systemctl daemon-reload

#Enable autoload after restart
sudo systemctl enable mongod

#Setup initial delay to let Mongodb enough time to startup 
sleep 10

#check if database with collections is exist(will return -1), if not create database and user

if [ $(mongo localhost:27017 --eval 'db.getMongo().getDBNames().indexOf("spark")' --quiet) -lt 0 ]; then
    echo "Creating database with collections and create database user"
# create database with collections users
    mongo 127.0.0.1:27017 --eval "db=db.getSiblingDB('spark'); db.createCollection('users');"
   # Add user to database
    mongo 127.0.0.1:27017 --eval "db=db.getSiblingDB('spark'); db.createUser({ user: 'iptcp', pwd: 'root', roles: [ {role: 'readWrite', db: 'spark'}]});"

else
    echo "Database with collections exist, exiting"
    exit 0
fi

#List created spark database
mongo 127.0.0.1:27017 --eval 'db.adminCommand( { listDatabases: 1, filter: { "name": /^spark/ } } )'

#List created admin user
mongo 127.0.0.1:27017 --eval "db.getSiblingDB('spark').getUsers({ filter: { "user": /^iptcp/ } })"