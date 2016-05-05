#!/bin/bash

. $HOME/workspace/work/openstack/config/openstack_exported.var
function sub_network(){

	local ifcfg_path=/etc/sysconfig/network-scripts/

	#to collect active network device:
	#declare -a devices=( $(nmcli device status | grep -E "ethernet[ ]+connected" | cut -d " " -f 1) )	

	local arg_hostname=$1
	echo "hostname: $arg_hostname"
	declare -a network_cfgs=( $(cat $openstack_network_conf | grep -E "$arg_hostname" ) )
	for network_cfg in $network_cfgs

	do
		echo "network config: $network_cfg"	
		#based on openstack_network.comfig format:
		local hostname=$(echo $network_cfg | cut -d "," -f 1)
		local connid=$(echo $network_cfg | cut -d "," -f 2)
		local device=$(echo $network_cfg | cut -d "," -f 3)	#make sure device exists
		local ipaddr=$(echo $network_cfg | cut -d "," -f 4)
		local maskbit=$(echo $network_cfg | cut -d "," -f 5)
		local bootproto=$(echo $network_cfg | cut -d "," -f 6)
		local gateway=$(echo $network_cfg | cut -d "," -f 7)
		local deployment=$(echo $network_cfg | cut -d "," -f 8)
		local hwseq=$(echo $network_cfg | cut -d "," -f 9)
		

		echo "hostname:	$hostname has been processed..."

		if [ $deployment == "manual" ]; then

			#check if ifcfg file exists
			local file_count=$(find $ifcfg_path -type f -name *$device | wc -l)
			#if file does not exist, then create one
			if [ $file_count -eq 0 ]; then
				sudo nmcli device disconnect $device
				sudo nmcli connection add type ethernet con-name $connid ifname $device ip4 $ipaddr/$maskbit gw4 $gateway
				sudo nmcli connection up $connid ifname $device
			fi
		fi
		
	done


}

sub_network $@
