#!/bin/bash

. $HOME/workspace/work/openstack/config/openstack_exported.var
function sub_(){

	local ifcfg_path=/etc/sysconfig/network-scripts/

	#to collect active network device:
	declare -a devices=( $(nmcli device status | grep -E "ethernet[ ]+connected" | cut -d " " -f 1) )	
	
	local conn=
	local ifname=
	local ipaddr=
	local prefix=
	local gateway=

	for device in $devices
	do
		#check if ifcfg file exists
		local file_count=$(find $ifcfg_path -type f -name *$device | wc -l)
		if [ $file_count -eq 0 ]; then
			#need to create one
			sudo nmcli device disconnect $device
			sudo nmcli connection add type ethernet con-name $conn ifname $ifname ip4 $ipaddr/$prefix gw4 $gateway 
			sudo nmcli connection up $conn ifname $ifname
		fi
			
			

	done

}

