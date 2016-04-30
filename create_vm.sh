#!/bin/bash


# creating vm fail on allocate network to instance.

. admin-openrc

neutron net-create --shared --provider:physical_network provider \
--provider:network_type flat provider

neutron subnet-create --name provider \
--allocation-pool start=203.0.113.101,end=203.0.113.250 \
--dns-nameserver 8.8.4.4 --gateway 203.0.113.1 provider 203.0.113.0/24


openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano

. demo-openrc

openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey
openstack keypair list
openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default
openstack flavor list
openstack image list
openstack network list
openstack security group list

openstack server create --flavor m1.tiny --image cirros --security-group default \
--key-name mykey provider-instance

