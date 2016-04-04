#su

mysql -u root -pSuper123 &> /dev/null << CREATEDB
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'Super123';
exit
CREATEDB

source admin-openrc.sh

#3
openstack user create --domain default --password Super123 glance
openstack role add --project service --user glance admin

#4
openstack service create --name glance --description "OpenStack Image service" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292

yum install -y openstack-glance python-glance python-glanceclient

#Edit the /etc/glance/glance-api.conf file
cp -f glance-api.conf /etc/glance/glance-api.conf

#Edit the /etc/glance/glance-registry.conf
cp -f glance-registry.conf /etc/glance/glance-registry.conf

su -s /bin/sh -c "glance-manage db_sync" glance

systemctl enable openstack-glance-api.service openstack-glance-registry.service
systemctl start openstack-glance-api.service openstack-glance-registry.service
