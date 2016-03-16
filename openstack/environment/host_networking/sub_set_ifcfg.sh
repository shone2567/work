#!/bin/bash
sub_create_ifcfg_mgmt(){
	local role=$1
	local role_id=$2
	local ifcfg_path=/etc/sysconfig/network-scripts/ifcfg-
	local ifcfg_file=
	local macaddr=
	local ipaddr=
	local netmask=
	local gateway=
	#get all nic interface name
	declare -a ifaces=( `ip -o link | grep -e "^...eno*" | cut -d " " -f 2 | cut -d ":" -f 1` )
	
	for iface in ${ifaces[*]}; do
		ifcfg_file=$ifcfg_path$iface
		
		#if ifcfg file doesn't exist
		#if file is already exisit then leave it.
		#if ifcfg file is missing then we will make it as management interface
		if [ ! -f $ifcfg_file ]; then
			macaddr=$(ip -o link | grep -e "$iface" | cut -d " " -f 18)
			sub_create_ifcfg_static $iface $macaddr $ipaddr $netmask $gateway 				
		fi
	
	done
}
. sub_create_ifcfg_static.sh

sub_create_ifcfg_mgmt $@
