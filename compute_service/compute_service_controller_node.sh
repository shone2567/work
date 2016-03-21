mysql -u root &> /dev/null << CREATEDB

CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';

CREATEDB 

source admin-openrc.sh

openstack user create --domain default --password-prompt nova
openstack role add --project service --user nova admin

openstack service create --name nova --description "OpenStack Compute" compute

openstack endpoint create --region RegionOne compute public http://controller:8774/v2/%\(tenant_id\)s

openstack endpoint create --region RegionOne compute internal http://controller:8774/v2/%\(tenant_id\)s

openstack endpoint create --region RegionOne compute admin http://controller:8774/v2/%\(tenant_id\)s

yum install openstack-nova-api openstack-nova-cert openstack-nova-conductor openstack-nova-console openstack-nova-novncproxy openstack-nova-scheduler python-novaclient




