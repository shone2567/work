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

ADMIN_TOKEN=$(openssl rand -hex 10)

#Install the packages

yum install -y openstack-keystone openstack-utils \
httpd mod_wsgi memcached python-memcached 

systemctl start  memcached.service
systemctl enable memcached.service

#Edit/create conf files

# edit keystone.conf

openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token $ADMIN_TOKEN
openstack-config --set /etc/keystone/keystone.conf database connection mysql://keystone:Super123@controller/keystone

openstack-config --set /etc/keystone/keystone.conf revoke driver sql
openstack-config --set /etc/keystone/keystone.conf memcache servers localhost:11211
openstack-config --set /etc/keystone/keystone.conf token provider uuid
openstack-config --set /etc/keystone/keystone.conf token driver memcache

su -s /bin/sh -c "keystone-manage db_sync" keystone

# edit httpd.conf

./sub_httpd_edited

# create_wsgi-keystone.conf

./sub_wsgi-keystone_create

# Create the service entity and API endpoints

export OS_TOKEN=$ADMIN_TOKEN
export OS_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

openstack service create \
  --name keystone --description "OpenStack Identity" identity

openstack endpoint create --region RegionOne \
  identity public http://controller:5000/v2.0

openstack endpoint create --region RegionOne \
  identity internal http://controller:5000/v2.0

 openstack endpoint create --region RegionOne \
  identity admin http://controller:35357/v2.0

#Create openstack project, user and roles 

openstack project create --domain default \
  --description "Admin Project" admin

openstack user create --domain default \
  --password-prompt admin

openstack role create admin

openstack role add --project admin --user admin admin

openstack project create --domain default \
  --description "Service Project" service

openstack project create --domain default \
  --description "Demo Project" demo

openstack user create --domain default \
  --password-prompt demo

openstack role create user

openstack role add --project demo --user demo user

#Verify


#need to modified /usr/share/keystone/keystone-dist-paste.ini

unset OS_TOKEN OS_URL#

#check token

openstack --os-auth-url http://controller:35357/v3 \
  --os-project-domain-id default --os-user-domain-id default \
  --os-project-name admin --os-username admin --os-auth-type password \
  token issue

