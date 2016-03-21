#!/bin/bash

set -x
#Create a database and an administration token
mysql - u root -pSuper123 << EOF
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
IDENTIFIED BY 'Super123';
EOF

#Generate admin token

admintoken=$(openssl rand -hex 10)


#Install the packages

#yum install -y openstack-keystone httpd mod_wsgi memcached python-memcached
#systemctl enable memcached.service
#systemctl enable memcached.service

#edit/create conf files

#./edit_keystone.conf
#./edit_httpd.conf
#./create_wsgi-keystone.conf


