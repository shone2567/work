#!/bin/bash

#firewall-cmd --add-port=5627/tcp --permanent
#firewall-cmd --reload

cd /root/work/networking_service

set -x
mysql -u root -pSuper123 << EOF
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
  IDENTIFIED BY 'Super123';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
  IDENTIFIED BY 'Super123';
EOF

. admin-openrc

#./sub_neutronuser_create.sh

openstack user create --domain default --password Super123 neutron

openstack role add --project service --user neutron admin

openstack service create --name neutron \
  --description "OpenStack Networking" network

openstack endpoint create --region RegionOne \
  network public http://controller:9696
openstack endpoint create --region RegionOne \
  network internal http://controller:9696
openstack endpoint create --region RegionOne \
  network admin http://controller:9696

echo "installing neutron package on controller"
yum install -y openstack-neutron openstack-neutron-ml2 \
  openstack-neutron-linuxbridge ebtables ipset &> /dev/null


openstack-config --set /etc/neutron/neutron.conf \
DEFAULT core_plugin ml2
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT service_plugins router
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT allow_overlapping_ips True
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT rpc_backend rabbit
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT auth_strategy keystone
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT notify_nova_on_port_status_changes  True
openstack-config --set /etc/neutron/neutron.conf \
DEFAULT notify_nova_on_port_data_changes  True
#openstack-config --set /etc/neutron/neutron.conf \
#DEFAULT nova_url http://controller:8774/v2


openstack-config --set /etc/neutron/neutron.conf \
database connection mysql+pymysql://neutron:Super123@controller/neutron

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
nova auth_url http://controller:35357
openstack-config --set /etc/neutron/neutron.conf \
nova auth_type password
openstack-config --set /etc/neutron/neutron.conf \
nova project_domain_name default
openstack-config --set /etc/neutron/neutron.conf \
nova user_domain_name default
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
ml2 type_drivers flat,vlan,vxlan
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini \
ml2 tenant_network_types vxlan
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini \
ml2 mechanism_drivers linuxbridge,l2population
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini \
ml2 extension_drivers port_security

openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini \
ml2_type_flat flat_networks provider

openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini \
ml2_type_vxlan vni_ranges 1:1000

openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini \
securitygroup enable_ipset True

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
linux_bridge physical_interface_mappings provider:enp0s8

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
vxlan enable_vxlan True
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
vxlan local_ip 10.0.0.11
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
vxlan l2_population True


openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
securitygroup enable_security_group True
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
securitygroup firewall_driver neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

openstack-config --set /etc/neutron/l3_agent.ini \
DEFAULT interface_driver neutron.agent.linux.interface.BridgeInterfaceDriver

openstack-config --set /etc/neutron/l3_agent.ini \
DEFAULT external_network_bridge 

openstack-config --set /etc/neutron/dhcp_agent.ini \
DEFAULT interface_driver neutron.agent.linux.interface.BridgeInterfaceDriver
openstack-config --set /etc/neutron/dhcp_agent.ini \
DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
openstack-config --set /etc/neutron/dhcp_agent.ini \
DEFAULT enable_isolated_metadata True

openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT nova_metadata_ip controller
openstack-config --set /etc/neutron/metadata_agent.ini \
DEFAULT metadata_proxy_shared_secret Super123

openstack-config --set /etc/nova/nova.conf \
neutron url http://controller:9696
openstack-config --set /etc/nova/nova.conf \
neutron auth_url http://controller:35357
openstack-config --set /etc/nova/nova.conf \
neutron auth_type password
openstack-config --set /etc/nova/nova.conf \
neutron project_domain_name default
openstack-config --set /etc/nova/nova.conf \
neutron user_domain_name default
openstack-config --set /etc/nova/nova.conf \
neutron region_name RegionOne
openstack-config --set /etc/nova/nova.conf \
neutron project_name service
openstack-config --set /etc/nova/nova.conf \
neutron username neutron
openstack-config --set /etc/nova/nova.conf \
neutron password Super123
openstack-config --set /etc/nova/nova.conf \
neutron service_metadata_proxy True
openstack-config --set /etc/nova/nova.conf \
neutron metadata_proxy_shared_secret Super123

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


if [ ! -f ~/.ssh/id_rsa ]; then
        echo "start connection"
        mkdir ~/.ssh
        chmod 700 ~/.ssh
        ssh-keygen -f id_rsa -t rsa -N ''
        cp id_rsa id_rsa.pub "/root/.ssh/"
        rm -f id_rsa id_rsa.pub
else
        echo "already have rsa keys"
fi

node_ip=10.0.0.31
./ssh_key_auth.sh $node_ip
scp ssh_key_auth.sh selfservice_compute_init.sh root@"$node_ip":~
ssh root@$node_ip '~/selfservice_compute_init.sh' &>> "$node_ip""_neutron_output" &

while [ ! -f ~/compute1_neutron_finished ]   #wait storage nodes finished
do
   echo "installing neutron service"
   sleep 10
done


#verify

. admin-openrc

neutron ext-list
neutron agent-list

exit 0
