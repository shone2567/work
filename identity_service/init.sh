#!/bin/bash

set -x

#Create a database and an administration token


mysql -u root -pSuper123 << EOF
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
  IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
  IDENTIFIED BY 'Super123';
EOF


#Generate admin token

cd /root/work/identity_service


ADMIN_TOKEN=$(openssl rand -hex 10)

#Install the packages

echo "installing keystone package on controller"

yum install -y openstack-keystone openstack-utils \
httpd mod_wsgi expect &> /dev/null 

yum install -y memcached python-memcached &> /dev/null

systemctl enable memcached.service
systemctl start memcached.service

#Edit/create conf files

# edit keystone.conf

openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token $ADMIN_TOKEN
openstack-config --set /etc/keystone/keystone.conf \
database connection mysql+pymysql://keystone:Super123@controller/keystone
openstack-config --set /etc/keystone/keystone.conf token provider fernet

su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone

/usr/sbin/semanage fcontext -a -t keystone_cgi_ra_content_t "/etc/keystone/fernet-keys(/.*)?"
/sbin/restorecon -R -v /etc/keystone/fernet-keys

# edit httpd.conf

./sub_httpd_edited.sh

# create_wsgi-keystone.conf

./sub_wsgikeystone_create.sh

systemctl enable httpd.service
systemctl start httpd.service

# Create the service entity and API endpoints

export OS_TOKEN=$ADMIN_TOKEN
export OS_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

openstack service create \
  --name keystone --description "OpenStack Identity" identity

openstack endpoint create --region RegionOne \
  identity public http://controller:5000/v3

openstack endpoint create --region RegionOne \
  identity internal http://controller:5000/v3

 openstack endpoint create --region RegionOne \
  identity admin http://controller:35357/v3

#Create openstack project, user and roles 

openstack domain create --description "Default Domain" default

openstack project create --domain default \
  --description "Admin Project" admin

#create a keystone admin user
source sub_keystoneadmin_create.sh

openstack role create admin

openstack role add --project admin --user admin admin

openstack project create --domain default \
  --description "Service Project" service

openstack project create --domain default \
  --description "Demo Project" demo

#create a keystone demo user
source sub_keystonedemo_create.sh

openstack role create user

openstack role add --project demo --user demo user

#Verify


#need to modified /usr/share/keystone/keystone-dist-paste.ini

./sub_keystone-dist-paste_edited.sh

unset OS_TOKEN OS_URL

#check token

./sub_keystone_verify.sh

/usr/sbin/semanage fcontext -a -t keystone_cgi_ra_content_t "/etc/keystone/fernet-keys(/.*)?" 
/sbin/restorecon -R -v /etc/keystone/fernet-keys

identityResult=$?

if [[ $identityResult -eq 1 ]]
then 
	echo "There is something wrong on installing identity service"
else
	echo "Pass identity service installation"
fi

# Create admin_openrc.sh and demo_openrc.sh

./sub_openrc_create.sh

exit 0







