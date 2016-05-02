mysql -u root -pSuper123 &> /dev/null << CREATEFILESYSTEM
CREATE DATABASE manila;
GRANT ALL PRIVILEGES ON manila.* TO 'manila'@'localhost' IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON manila.* TO 'manila'@'%' IDENTIFIED BY 'Super123';
EXIT
CREATEFILESYSTEM

. admin-openrc
openstack user create --domain default --password Super123 manila
openstack role add --project service --user manila admin
openstack service create --name manila --description "OpenStack Shared File Systems" share
openstack service create --name manilav2 --description "OpenStack Shared File Systems" sharev2
openstack endpoint create --region RegionOne share public http://controller:8786/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne share internal http://controller:8786/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne share admin http://controller:8786/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne sharev2 public http://controller:8786/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne sharev2 internal http://controller:8786/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne sharev2 admin http://controller:8786/v2/%\(tenant_id\)s


yum install -y openstack-manila python-manilaclient

