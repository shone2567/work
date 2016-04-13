#!/bin/bash

set -x

yum -y install openstack-neutron-linuxbridge ebtables ipset

openstack-config --set /etc/neutron/neutron.conf \
DEFAULT rpc_backend rabbit
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT auth_strategy keystone
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT verbose True

openstack-config --set /etc/neutron/neutron.conf \
oslo_messaging_rabbit rabbit_host controller
openstack-config --set /etc/neutron/neutron.conf \
oslo_messaging_rabbit rabbit_userid openstack
openstack-config --set /etc/neutron/neutron.conf \
oslo_messaging_rabbit rabbit_password Super123


openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken auth_uri http://controller:5000
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken auth_url http://controller:35357
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken memcached_servers controller:11211

openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken auth_type password
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken project_domain_name default
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken user_domain_name default
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken project_name service
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken username neutron
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken password Super123

openstack-config --set /etc/neutron/neutron.conf \
oslo_concurrency lock_path /var/lib/neutron/tmp

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
linux_bridge physical_interface_mappings provider:enp0s8

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
vxlan enable_vxlan False

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
securitygroup enable_security_group True
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
securitygroup firewall_driver neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

openstack-config --set /etc/nova/nova.conf \
DEFAULT url http://controller:9696
openstack-config --set /etc/nova/nova.conf \
DEFAULT auth_url http://controller:35357
penstack-config --set /etc/nova/nova.conf \
DEFAULT auth_type password
openstack-config --set /etc/nova/nova.conf \
DEFAULT region_name RegionOne
openstack-config --set /etc/nova/nova.conf \
DEFAULT project_domain_name default
openstack-config --set /etc/nova/nova.conf \
DEFAULT user_domain_name default
openstack-config --set /etc/nova/nova.conf \
DEFAULT project_name service
openstack-config --set /etc/nova/nova.conf \
DEFAULT username neutron
openstack-config --set /etc/nova/nova.conf \
DEFAULT password Super123

systemctl restart openstack-nova-compute.service
systemctl enable neutron-linuxbridge-agent.service
systemctl start neutron-linuxbridge-agent.service

exit 0
