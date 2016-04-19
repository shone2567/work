mysql -u root -pSuper123 &> /dev/null << CREATECINDER 
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'Super123';
EXIT
CREATECINDER

. admin-openrc
openstack user create --domain default --password Super123 cinder
openstack role add --project service --user cinder admin

openstack service create --name cinder --description "OpenStack Block Storage" volume

openstack service create --name cinderv2  --description "OpenStack Block Storage" volumev2

openstack endpoint create --region RegionOne volume public http://controller:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne volume internal http://controller:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne volume admin http://controller:8776/v1/%\(tenant_id\)s

openstack endpoint create --region RegionOne volumev2 public http://controller:8776/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne volumev2 internal http://controller:8776/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne volumev2 admin http://controller:8776/v2/%\(tenant_id\)s

yum install -y openstack-cinder

cp -f cinder.conf /etc/cinder/

su -s /bin/sh -c "cinder-manage db sync" cinder

openstack-config --set /etc/nova/nova.conf \
cinder os_region_name RegionOne

systemctl restart openstack-nova-api.service
systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.servicesystemctl start openstack-cinder-api.service openstack-cinder-scheduler.service

firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --zone=public --add-port=123/udp --permanent
systemctl restart firewalld
