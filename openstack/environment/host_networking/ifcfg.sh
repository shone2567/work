#!/bin/bash

. $HOME/workspace/work/openstack/config/openstack_exported.var
ifcfg(){
	local arg_hostname=
	local arg_iftype=
	local field_hostname=1
	local field_iface=2
	local field_ifacetype=3
	local field_ipaddr=4
	local field_netmask=5
	local field_bootproto=6
	local field_gateway=7		
	local field_deployment=8
	local field_hwseq=9
	declare -a ifaces


#	option handling
   for opt in $@
   do
      case $opt in
         --help*)
				>&2 cat <<-HELP
				usage: $0 
				--host_name=<host name>
				HELP
         ;;
			--host_name=*)
				arg_hostname="${opt#*=}"
			;;				
			*)
				#do nothiing so far...
			;;
      esac
   done
	#argument and ption requirement check (output to stderr)
	if [ ${#arg_hostname} -eq 0 ]; then
		>&2 cat <<-ERR
			error: host_name is not defined
		ERR
		exit 1	
	
	fi 
	#collecting all eth (interfaces) info based on $host_name and its interface type specified)
#	local network_info=$(cat $openstack_network_conf | grep -E "$host_name" | grep -E "$if_type")

	declare network_configs=( $(cat $openstack_network_conf | grep -E "$arg_hostname") )
	local host_name=
	local iface=
	local ifacetype=
	local ipaddr=
	local netmask=
	local bootproto=
	local gateway=
	local deployment=
	local hwseq=
	local sys_ifcfg_file=/etc/sysconfig/network-scripts/ifcfg-

	#if no config info found:	
	for nw_config in $network_configs
	do
			
		host_name=$(echo $nw_config | cut -d "," -f $field_hostname)
		iface=$(echo $nw_config | cut -d "," -f $field_iface)
		ifacetype=$(echo $nw_config | cut -d "," -f $field_ifacetype)
		ipaddr=$(echo $nw_config | cut -d "," -f $field_ipaddr)
		netmask=$(echo $nw_config | cut -d "," -f $field_netmask)
		bootproto=$(echo $nw_config | cut -d "," -f $field_bootproto)
		gateway=$(echo $nw_config | cut -d "," -f $field_gateway)
		deployment=$(echo $nw_config | cut -d "," -f $field_deployment)
		hwseq=$(echo $nw_config | cut -d "," -f $field_hwseq)

		if [ $deployment == "auto" ]; then
			#process based on exisiting ifcfg file
			>&2 echo "place holder: to read from existing ifcfg file..."
			cat "$ifcfg_file$iface"
		elif [ $deployment == "manual" ]; then

			if [ $bootproto == "dhcp" ]; then
				cat <<-OUTPUT
					DEVICE=$iface
					BOOTPROTO=$bootproto
					NAME=$iface
					ONBOOT=yes
				OUTPUT
			elif [ $bootproto == "none" -o $bootproto == "static" ]; then 
				cat <<-OUTPUT
					DEVICE=$iface
					BOOTPROTO=none
					NAME=$iface
					ONBOOT=yes
					NETMASK=$netmask
					IPADDR=$ipaddr
					USERCTL=no
				OUTPUT
			fi

		else
			>&2 echo "info: deployment=$deployment: no case found" 
		fi

	done

	if [ ${#network_configs} -eq 0 ]; then

		>&2 cat <<-ERR
			info: network config info not found.
			(hint: cannot find network config info for the host specified.) 
		ERR
	
	fi 


	exit 0
}

ifcfg $@
