#!/bin/bash

. $HOME/workspace/work/openstack/config/openstack_exported.var
ifcfg(){
	local host_name=
	local if_type=
	local field_hostname=1
	local field_iface=2
	local field_iface_type=3
	local field_ipaddr=4
	local field_netmask=5
	local field_bootproto=6
	local field_gateway=7		
	declare -a ifaces


#	option handling
   for opt in $@
   do
      case $opt in
         --help*)
				cat <<-HELP
				usage: $0 --host_name=<host name> \
				--if_type=<pub|internal>
				HELP
         ;;
			--host_name=*)
				host_name="${opt#*=}"
			;;				
			--if_type=*)
				if_type="${opt#*=}"
			;;
      esac
   done
	#argument and ption requirement check
	if [ ${#host_name} -eq 0 ]; then
		cat <<-ERR
			info: host_name is not defined
		ERR
		exit 1	
	
	fi 
	#collecting all eth (interfaces) info based on $host_name and its interface type specified)
	local network_info=$(cat $openstack_network_conf | grep -E "$host_name" | grep -E "$if_type")
	#if no config info found:	
	if [ ${#network_info} -eq 0 ]; then
		cat <<-ERR
			info: network config info not found. (hint: 
			pls check if it is valid host name and/or interface type.
		ERR
		exit 1	
	
	fi 
	local host_name=$(echo $network_info | cut -d "," -f $field_hostname)
	local iface=$(echo $network_info | cut -d "," -f $field_iface)
	local iface_type=$(echo $network_info | cut -d "," -f $field_iface_type)
	local ipaddr=$(echo $network_info | cut -d "," -f $field_ipaddr)
	local netmask=$(echo $network_info | cut -d "," -f $field_netmask)
	local bootproto=$(echo $network_info | cut -d "," -f $field_bootproto)
	local gateway=$(echo $network_info | cut -d "," -f $field_gateway)
	if [ $bootproto == "dhcp" ]; then
		cat <<-OUTPUT
			DEVICE=$iface
			BOOTPROTO=$bootproto
			ONBOOT=yes
		OUTPUT
	else #if static ip address
		cat <<-OUTPUT
			DEVICE=$iface
			BOOTPROTO=$bootproto
			ONBOOT=yes
			NETMASK=$netmask
			IPADDR=$ipaddr
			USERCTL=no
		OUTPUT
	fi
	exit 0
}

ifcfg $@
