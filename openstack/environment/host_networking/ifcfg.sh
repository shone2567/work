#!/bin/bash

. $HOME/workspace/work/openstack/config/openstack_exported.var
function ifcfg(){
	local host_name=
	local field_hostname=1
	local field_iface=2
	local field_iface_type=3
	local field_ipaddr=4
	local field_netmask=5
	local field_bootproto=6
	local field_gateway=7		
	declare -a ifaces
	ifaces=( $(cat $openstack_network_conf | grep -E "$host_name" | cut -d "," -f field_iface) )
	 
	for iface in $ifaces
	do
		:
	done



#	option handling
   for o in $@
   do
      case $o in
         --help*)
				cat <<-HELP
				usage: $0 --host_name=<host name>
				HELP
         ;;
			--host_name=*)
				host_name="${o#*=}"
				
			;;				
      esac
   done
	#check node type based on host name
		
	case $node_type in
		controller)
		;;
		compute)
		;;
		block_storage)
		;;
		object_storage)
		;;
		
	esac
}

ifcfg $@
