#!/bin/bash


set -x
cd /root/work/glance_service

firewall-cmd --add-port=9393/tcp --permanent
firewall-cmd --reload

mysql -u root -pSuper123 << EOF
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
  IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
  IDENTIFIED BY 'Super123';
EOF
. admin-openrc
yum -y install expect &>/dev/null

#create glanceuser

./sub_glanceuser_create.sh

openstack role add --project service --user glance admin

openstack service create --name glance \
  --description "OpenStack Image service" image

openstack endpoint create --region RegionOne \
  image public http://controller:9292

openstack endpoint create --region RegionOne \
  image internal http://controller:9292

openstack endpoint create --region RegionOne \
  image admin http://controller:9292

echo "installing glance package on controller"
yum -y install openstack-glance wget &>/dev/null

openstack-config --set /etc/glance/glance-api.conf database \
connection mysql+pymysql://glance:Super123@controller/glance

openstack-config --set /etc/glance/glance-api.conf keystone_authtoken \
auth_uri http://controller:5000

openstack-config --set /etc/glance/glance-api.conf keystone_authtoken \
auth_url http://controller:35357

openstack-config --set /etc/glance/glance-api.conf keystone_authtoken \
memcached_servers controller:11211

openstack-config --set /etc/glance/glance-api.conf keystone_authtoken \
auth_type password

openstack-config --set /etc/glance/glance-api.conf keystone_authtoken \
project_domain_name default

openstack-config --set /etc/glance/glance-api.conf keystone_authtoken \
user_domain_name default

openstack-config --set /etc/glance/glance-api.conf keystone_authtoken \
project_name service

openstack-config --set /etc/glance/glance-api.conf keystone_authtoken \
username glance

openstack-config --set /etc/glance/glance-api.conf keystone_authtoken \
password Super123

openstack-config --set /etc/glance/glance-api.conf paste_deploy \
flavor keystone

openstack-config --set /etc/glance/glance-api.conf glance_store \
default_store file

openstack-config --set /etc/glance/glance-api.conf glance_store \
store file,http

openstack-config --set /etc/glance/glance-api.conf glance_store \
filesystem_store_datadir /var/lib/glance/images/

openstack-config --set /etc/glance/glance-api.conf DEFAULT \
verbose True


openstack-config --set /etc/glance/glance-registry.conf database \
connection mysql+pymysql://glance:Super123@controller/glance

openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken \
auth_uri http://controller:5000

openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken \
auth_url http://controller:35357

openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken \
memcached_servers controller:11211

openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken \
auth_type password

openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken \
project_domain_name default

openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken \
user_domain_name default

openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken \
project_name service

openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken \
username glance

openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken \
password Super123

openstack-config --set /etc/glance/glance-registry.conf paste_deploy \
flavor keystone


openstack-config --set /etc/glance/glance-registry.conf DEFAULT \
verbose True

su -s /bin/sh -c "glance-manage db_sync" glance

systemctl enable openstack-glance-api.service \
  openstack-glance-registry.service

systemctl start openstack-glance-api.service \
  openstack-glance-registry.service

#Verify

wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img

echo "export OS_IMAGE_API_VERSION=2" \  | tee -a admin-openrc demo-openrc
. admin-openrc

glance image-create --name "cirros" \
  --file cirros-0.3.4-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --visibility public --progress

glance image-list

glaneceResult=$?

if [[ $glanceResult -eq 1 ]]
then 
	echo "There is something wrong on installing glance service"
else
	echo "Pass glance service installation"
fi

rm -f cirros-0.3.4-x86_64-disk.img

exit 0
