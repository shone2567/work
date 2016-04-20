#su

mysql -u root -pSuper123 &> /dev/null << CREATEDB_COMPUTE_CONTROLLER
CREATE DATABASE nova_api;
CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'Super123';
EXIT
CREATEDB_COMPUTE_CONTROLLER

#. admin-openrc
. /compute_service_mitaka/compute_service_for_controller/admin-openrc

openstack user create --domain default --password Super123 nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute

openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1/%\(tenant_id\)s

yum install -y openstack-nova-api openstack-nova-cert openstack-nova-conductor openstack-nova-console openstack-nova-novncproxy openstack-nova-scheduler

#Edit the /etc/nova/nova.conf file
#cp -f nova.conf /etc/nova/
openstack-config --set /etc/nova/nova.conf DEFAULT enabled_apis osapi_compute,metadata

openstack-config --set /etc/nova/nova.conf api_database connection mysql+pymysql://nova:Super123@controller/nova

openstack-config --set /etc/nova/nova.conf DEFAULT rpc_backend rabbit

openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_host controller

openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_userid openstack

openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_password Super123

openstack-config --set /etc/nova/nova.conf DEFAULT auth_strategy keystone

openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_uri http://controller:5000

openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_url http://controller:35357

openstack-config --set /etc/nova/nova.conf keystone_authtoken memcached_servers controller:11211

openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_type password

openstack-config --set /etc/nova/nova.conf keystone_authtoken project_domain_name default

openstack-config --set /etc/nova/nova.conf keystone_authtoken user_domain_name default

openstack-config --set /etc/nova/nova.conf keystone_authtoken project_name service

openstack-config --set /etc/nova/nova.conf keystone_authtoken username nova

openstack-config --set /etc/nova/nova.conf keystone_authtoken password Super123

openstack-config --set /etc/nova/nova.conf DEFAULT my_ip 10.0.0.11

openstack-config --set /etc/nova/nova.conf DEFAULT use_neutron True

openstack-config --set /etc/nova/nova.conf DEFAULT firewall_driver  nova.virt.firewall.NoopFirewallDriver

openstack-config --set /etc/nova/nova.conf vnc vncserver_listen $my_ip

openstack-config --set /etc/nova/nova.conf vnc vncserver_proxyclient_address $my_ip

openstack-config --set /etc/nova/nova.conf glance api_servers http://controller:9292

openstack-config --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp

su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage db sync" nova

systemctl enable openstack-nova-api.service openstack-nova-cert.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service

systemctl start openstack-nova-api.service openstack-nova-cert.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service

firewall-cmd --zone=public --add-port=5672 --permanent
systemctl restart firewalld

#iptables -A IN_public_allow -p tcp -m tcp --dport 5672 -m conntrack --ctstate NEW -j ACCEPT
