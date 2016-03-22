#su

mysql -u root &> /dev/null << CREATEDB
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'GLANCE_DBPASS';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'GLANCE_DBPASS';
exit
CREATEDB

source admin-openrc.sh

#3
openstack user create --domain default --password-prompt glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image service" image

#4
openstack endpoint create --region RegionOne image public http://controller:9292openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

yum install openstack-glance python-glance python-glanceclie

#Edit the /etc/glance/glance-api.conf file
cp -f glance-api.conf /etc/glance/glance-api.conf

#Edit the /etc/glance/glance-registry.conf
cp -f glance-registry.conf /etc/glance/glance-registry.conf

su -s /bin/sh -c "glance-manage db_sync" glance

systemctl enable openstack-glance-api.service openstack-glance-registry.service
systemctl start openstack-glance-api.service openstack-glance-registry.service
