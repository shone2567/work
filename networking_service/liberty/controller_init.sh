#!/bin/bash

yum install -y expect
set -x
mysql -u root -pSuper123 << EOF
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
  IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
  IDENTIFIED BY 'Super123';
EOF

source admin-openrc.sh

./sub_neutronuser_create.sh

openstack role add --project service --user neutron admin

openstack service create --name neutron \
  --description "OpenStack Networking" network

openstack endpoint create --region RegionOne \
  network public http://controller:9696
openstack endpoint create --region RegionOne \
  network internal http://controller:9696
openstack endpoint create --region RegionOne \
  network admin http://controller:9696


yum install -y openstack-neutron openstack-neutron-ml2 \
  openstack-neutron-linuxbridge python-neutronclient ebtables ipset


openstack-config --set /etc/neutron/neutron.conf \
DEFAULT core_plugin ml2
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT service_plugins
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT rpc_backend rabbit
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT auth_strategy  keystone
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT notify_nova_on_port_status_changes  True
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT notify_nova_on_port_data_changes  True
#openstack-config --set /etc/neutron/neutron.conf \
#DEFAULT nova_url http://controller:8774/v2
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT verbose True


openstack-config --set /etc/neutron/neutron.conf \
database connection mysql://neutron:Super123@controller/neutron

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
nova auth_url http://controller:35357
openstack-config --set /etc/neutron/neutron.conf \
nova auth_plugin password
openstack-config --set /etc/neutron/neutron.conf \
nova project_domain_id default
openstack-config --set /etc/neutron/neutron.conf \
nova user_domain_id default
openstack-config --set /etc/neutron/neutron.conf \
nova region_name RegionOne
openstack-config --set /etc/neutron/neutron.conf \
nova project_name service
openstack-config --set /etc/neutron/neutron.conf \
nova username nova
openstack-config --set /etc/neutron/neutron.conf \
nova password Super123

openstack-config --set /etc/neutron/neutron.conf \
oslo_concurrency lock_path /var/lib/neutron/tmp

openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini \
ml2 type_drivers flat,vlan
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini \
ml2 tenant_network_types
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini \
ml2 mechanism_drivers linuxbridge
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini \
ml2 extension_drivers port_security

openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini \
ml2_type_flat flat_networks public

openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini \
securitygroup enable_ipset True

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

openstack-config --set /etc/neutron/dhcp_agent.ini \
DEFAULT interface_driver neutron.agent.linux.interface.BridgeInterfaceDriver
openstack-config --set /etc/neutron/dhcp_agent.ini \
DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
openstack-config --set /etc/neutron/dhcp_agent.ini \
DEFAULT enable_isolated_metadata True
openstack-config --set /etc/neutron/dhcp_agent.ini \
DEFAULT verbose True

openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT auth_uri http://controller:5000
openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT auth_url http://controller:35357
openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT auth_region RegionOne
openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT auth_plugin password
openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT project_domain_id default
openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT user_domain_id default
openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT project_name service
openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT username neutron
openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT password Super123
openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT nova_metadata_ip controller
openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT metadata_proxy_shared_secret Super123
openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT verbose True

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
openstack-config --set /etc/nova/nova.conf \
DEFAULT service_metadata_proxy True
openstack-config --set /etc/nova/nova.conf \
DEFAULT metadata_proxy_shared_secret Super123
openstack-config --set /etc/nova/nova.conf \
DEFAULT verbose True

ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

systemctl restart openstack-nova-api.service

systemctl enable neutron-server.service \
  neutron-linuxbridge-agent.service neutron-dhcp-agent.service \
  neutron-metadata-agent.service

systemctl start neutron-server.service \
  neutron-linuxbridge-agent.service neutron-dhcp-agent.service \
  neutron-metadata-agent.service

sudo iptables -A IN_public_allow -p tcp -m tcp --dport 5672 -m conntrack --ctstate NEW -j ACCEPT

#verify

source admin-openrc.sh

neutron ext-list



