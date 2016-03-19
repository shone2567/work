#!/bin/bash

. $HOME/workspace/work/openstack/config/openstack_exported.var
function sub_(){
	local host_name=
	local node_type=
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

