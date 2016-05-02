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

openstack-config --set /etc/manila/manila.conf database connection mysql+pymysql://manila:Super123@controller/manila
openstack-config --set /etc/manila/manila.conf DEFAULT rpc_backend rabbit
openstack-config --set /etc/manila/manila.conf oslo_messaging_rabbit rabbit_host controller
openstack-config --set /etc/manila/manila.conf oslo_messaging_rabbit rabbit_userid openstack
openstack-config --set /etc/manila/manila.conf oslo_messaging_rabbit rabbit_password Super123
openstack-config --set /etc/manila/manila.conf DEFAULT default_share_type default_share_type
openstack-config --set /etc/manila/manila.conf DEFAULT rootwrap_config /etc/manila/rootwrap.conf
openstack-config --set /etc/manila/manila.conf DEFAULT auth_strategy keystone
openstack-config --set /etc/manila/manila.conf keystone_authtoken memcached_servers controller:11211
openstack-config --set /etc/manila/manila.conf keystone_authtoken auth_uri http://controller:5000
openstack-config --set /etc/manila/manila.conf keystone_authtoken auth_url http://controller:35357
openstack-config --set /etc/manila/manila.conf keystone_authtoken auth_type password
openstack-config --set /etc/manila/manila.conf keystone_authtoken project_domain_name default
openstack-config --set /etc/manila/manila.conf keystone_authtoken user_domain_name default
openstack-config --set /etc/manila/manila.conf keystone_authtoken project_name service
openstack-config --set /etc/manila/manila.conf keystone_authtoken username manila
openstack-config --set /etc/manila/manila.conf keystone_authtoken password Super123
openstack-config --set /etc/manila/manila.conf DEFAULT my_ip 10.0.0.11
openstack-config --set /etc/manila/manila.conf oslo_concurrency lock_path /var/lib/manila/tmp

su -s /bin/sh -c "manila-manage db sync" manila
systemctl enable openstack-manila-api.service openstack-manila-scheduler.service
systemctl start openstack-manila-api.service openstack-manila-scheduler.service

