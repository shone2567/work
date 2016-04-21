#su

yum install -y openstack-nova-compute

acceleration=`egrep -c '(vmx|svm)' /proc/cpuinfo`
echo $acceleration

if [ $acceleration -eq 0 ];
then
#cp -f nova_not_support_hw_acceleration/nova.conf /etc/nova;
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
	openstack-config --set /etc/nova/nova.conf DEFAULT my_ip 10.0.0.31
	openstack-config --set /etc/nova/nova.conf DEFAULT use_neutron True
	openstack-config --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
	openstack-config --set /etc/nova/nova.conf vnc enabled True
	openstack-config --set /etc/nova/nova.conf vnc vncserver_listen 0.0.0.0
	openstack-config --set /etc/nova/nova.conf vnc vncserver_proxyclient_address $my_ip
	openstack-config --set /etc/nova/nova.conf vnc novncproxy_base_url http://controller:6080/vnc_auto.html
	openstack-config --set /etc/nova/nova.conf glance api_servers http://controller:9292
	openstack-config --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp

else
#cp -f nova_support_hw_acceleration/nova.conf /etc/nova;
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
        openstack-config --set /etc/nova/nova.conf DEFAULT my_ip 10.0.0.31
        openstack-config --set /etc/nova/nova.conf DEFAULT use_neutron True
        openstack-config --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
        openstack-config --set /etc/nova/nova.conf vnc enabled True
        openstack-config --set /etc/nova/nova.conf vnc vncserver_listen 0.0.0.0
        openstack-config --set /etc/nova/nova.conf vnc vncserver_proxyclient_address $my_ip
        openstack-config --set /etc/nova/nova.conf vnc novncproxy_base_url http://controller:6080/vnc_auto.html
        openstack-config --set /etc/nova/nova.conf glance api_servers http://controller:9292
        openstack-config --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp
	openstack-config --set /etc/nova/nova.conf libvirt virt_type qemu
fi

#Edit the [libvirt] section in the /etc/nova/nova.conf file

systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service openstack-nova-compute.service
