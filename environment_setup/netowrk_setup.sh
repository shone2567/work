#!/bin/bash

#sed -i 's/^ONBOOT=.*/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-enp0s3
#sed -i 's/^BOOTPROTO=.*/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-enp0s3


case $1 in
--help*)
cat <<-HELP

useage: ./network_setup.sh IP

HELP
exit
;;
esac

#  comment now due to the assumption that we have internet access before deployment

#sed -i.bak 's/^ONBOOT=.*/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-enp0s3
#sed -i 's/^BOOTPROTO=.*/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-enp0s3
#echo "IPADDR=$1" >> /etc/sysconfig/network-scripts/ifcfg-enp0s3

#cat <<EOF >> /etc/sysconfig/network-scripts/ifcfg-enp0s3
#NETMASK=255.255.255.0
#GATEWAY=10.0.0.1
#EOF

#echo "nameserver 8.8.8.8" >> /etc/hosts

sed -i.bak '/UUID=.*/!d' /etc/sysconfig/network-scripts/ifcfg-enp0s8
cat <<EOF >> /etc/sysconfig/network-scripts/ifcfg-enp0s8
DEVICE=enp0s8
TYPE=Ethernet
ONBOOT="yes"
BOOTPROTO="none"
EOF

cat <<EOF >> /etc/hosts
# controller
10.0.0.11       controller

# compute1
10.0.0.31       compute1

# block1
10.0.0.41       block1

# object1
10.0.0.51       object1

# object2
10.0.0.52       object2
EOF



