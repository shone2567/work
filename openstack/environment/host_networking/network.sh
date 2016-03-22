#!/bin/bash

. $HOME/workspace/work/openstack/config/openstack_exported.var
function sub_(){

	local ifcfg_path=/etc/sysconfig/network-scripts/

	#to collect active network device:
	declare -a devices=( $(nmcli device status | grep -E "ethernet[ ]+connected" | cut -d " " -f 1) )	
	local arg_hostname=$1
	local conn=
	local ifname=
	local ipaddr=
	local prefix=
	local gateway=
	
	declare -a nework_cfgs=( $(cat $openstack_network_conf | grep -E "$arg_hostname" ) )
	for network_cfg in $network_cfgs
	do
		local hostname=$(echo $network_cfg | cut -d "," -f 1)
		local connid=$(echo $network_cfg | cut -d "," -f 2)
		local device=$(echo $network_cfg | cut -d "," -f 3)
		local ipaddr=$(echo $network_cfg | cut -d "," -f 4)
		local netmaskbit=$(echo $network_cfg | cut -d "," -f 5)
		local bootproto=$(echo $network_cfg | cut -d "," -f 6)
		local gateway=$(echo $network_cfg | cut -d "," -f 7)
		local deployment=$(echo $network_cfg | cut -d "," -f 8)
		local hwseq=$(echo $network_cfg | cut -d "," -f 9)
		
		if [ $device == "manual" ]; then

			#check if ifcfg file exists
			local file_count=$(find $ifcfg_path -type f -name *$device | wc -l)
		fi
		
	done

		if [ $file_count -eq 0 ]; then
			#need to create one
			sudo nmcli device disconnect $device
			sudo nmcli connection add type ethernet con-name $conn ifname $ifname ip4 $ipaddr/$prefix gw4 $gateway 
			sudo nmcli connection up $conn ifname $ifname
		fi
			
			

	done

}

