#!/bin/bash


# creating vm fail on allocate network to instance.

. admin-openrc

neutron net-create --shared --provider:physical_network provider \
--provider:network_type flat provider

neutron subnet-create --name provider2 --allocation-pool start=10.0.0.60,end=10.0.0.100 \
--dns-nameserver 8.8.8.8 --gateway 10.0.0.1 provider 10.0.0.0/24

. demo-openrc

openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey
openstack keypair list
openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default
openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano
openstack flavor list
openstack image list
openstack network list
openstack security group list

openstack server create --flavor m1.tiny --image cirros --security-group default \
--key-name mykey provider-instance

