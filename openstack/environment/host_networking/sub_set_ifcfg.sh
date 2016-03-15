#!/bin/bash


sub_set_ifcfg(){
	local iface=
	local ifcfg_path=/etc/sysconfig/network-scripts/ifcfg-
	local ifcfg_file=
	local hwaddr=
	local bootprot=static
	local ipaddr=$1
	local netmask=255.255.255.0
	local gateway=$2
	local name=
	local onboot=yes
	#get all nic interface name
	declare -a ifs=( `ip -o link | grep -E "^...eno*" | cut -d " " -f 2 | cut -d ":" -f 1` )
	if [ $# -lt 2 ]; then
		echo -e "usage: $0 <mgmt-ipaddr> <mgmt-netmask> <mgmt-gateway>"
	fi

	for iface in ${ifs[*]}; do
		#ipaddr=$(ip -o address | grep -E "$iface( )+inet( )+" | sed -e "s/ /|/g" | cut -d "|" -f 7 | cut -d "/" -f 1)
		hwaddr=$(ip -o link | grep -e "$iface" | cut -d " " -f 18)
		ifcfg_file=$ifcfg_path$iface
	     	echo -e "$iface\t$hwaddr\t$ifcfg_file"

		#check if the cfg file exist:
		if [ -e $ifcfg_file ]; then
			echo -e "$ifcfg_file exist"
			
			
		else
			echo -e "$ifcfg_file doesn't exist"
			#creating a new ifcfg file.
			touch $ifcfg_file
			cat <<- CFG > $ifcfg_file
			DEVICE=$iface
			IPADDR=$ipaddr
			NETMASK=255.255.255.0
			GATEWAY=10.0.0.1
			TYPE=Ethernet
			BOOTPROTO=static
			NAME=$iface
			ONBOOT=yes
			HWADDR=$hwaddr
			CFG
		fi	
	done

}

