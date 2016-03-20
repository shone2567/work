#!/bin/bash


#Create a database and an administration token
mysql - u root -pSuper123 << EOF
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
IDENTIFIED BY 'Super123';
EOF

#Generate admin token

$admintoken=$(openssl rand -hex 10)





