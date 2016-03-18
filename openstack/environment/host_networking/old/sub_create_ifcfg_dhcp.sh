#!/bin/bash
. sub_create_ifcfg.sh
#
#$1= device
#$2= mac address
#$3= ip address
#$4= netmask
#$5= gateway
if [ ${#@} -lt 5 ]; then
	echo "error: usage $0 <device> <mac address> "
	exit 1
fi
sub_create_ifcfg --device=$1 --bootproto=dhcp --onboot=yes --hwaddr=$2 --type=Ethernet

