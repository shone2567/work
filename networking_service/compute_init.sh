#!/bin/bash

yum -y install openstack-neutron openstack-neutron-linuxbridge ebtables ipset openstack-utils

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
oslo_messaging_rabbit rabbit_password :Super123


openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken auth_uri http://controller:5000
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken auth_url http://controller:35357
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken auth_plugin password
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken project_domain_id default
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken user_domain_id default
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken project_name service
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken username neutron
openstack-config --set /etc/neutron/neutron.conf \
keystone_authtoken password Super123

openstack-config --set /etc/neutron/neutron.conf \
oslo_concurrency lock_path /var/lib/neutron/tmp

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
linux_bridge physical_interface_mappings public:enp0s8

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
vxlan enable_vxlan False

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
agent prevent_arp_spoofing True

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
securitygroup enable_security_group True
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
securitygroup firewall_driver neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

openstack-config --set /etc/nova/nova.conf \
DEFAULT url http://controller:9696
openstack-config --set /etc/nova/nova.conf \
DEFAULT auth_url http://controller:35357
openstack-config --set /etc/nova/nova.conf \
DEFAULT auth_region RegionOne
openstack-config --set /etc/nova/nova.conf \
DEFAULT auth_plugin password
openstack-config --set /etc/nova/nova.conf \
DEFAULT project_domain_id default
openstack-config --set /etc/nova/nova.conf \
DEFAULT user_domain_id default
openstack-config --set /etc/nova/nova.conf \
DEFAULT project_name service
openstack-config --set /etc/nova/nova.conf \
DEFAULT username neutron
openstack-config --set /etc/nova/nova.conf \
DEFAULT password Super123
DEFAULT verbose True

systemctl restart openstack-nova-compute.service
systemctl enable neutron-linuxbridge-agent.service
systemctl start neutron-linuxbridge-agent.service

