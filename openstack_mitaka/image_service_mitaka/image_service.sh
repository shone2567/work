#su

mysql -u root -pSuper123 &> /dev/null << CREATEDB
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'Super123';
EXIT
CREATEDB

. admin-openrc

#3
openstack user create --domain default --password Super123 glance
openstack role add --project service --user glance admin

#4
openstack service create --name glance --description "OpenStack Image service" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

yum install -y openstack-glance

#Edit the /etc/glance/glance-api.conf file
cp -f glance-api.conf /etc/glance/

#Edit the /etc/glance/glance-registry.conf
cp -f glance-registry.conf /etc/glance/

su -s /bin/sh -c "glance-manage db_sync" glance

systemctl enable openstack-glance-api.service openstack-glance-registry.service
systemctl start openstack-glance-api.service openstack-glance-registry.service

. admin-openrc

yum install -y wget
wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img

openstack image create "cirros" --file cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare --public

openstack image list
