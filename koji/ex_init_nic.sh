#!/bin/bash

#Check network interface name by ifconfig e.g. <ethxxx>
if_name=$(ifconfig | grep -E "BROADCAST,RUNNING,MULTICAST" | cut -d : -f 1)
ifcfg_file=/etc/sysconfig/network-scripts/ifcfg-$if_name
cat $ifcfg_file
perl -pi -e "s/ONBOOT=no/ONBOOT=yes/g" ifcfg_file
echo "=====	after modification	====="
cat $ifcfg_file
ifup $if_name

