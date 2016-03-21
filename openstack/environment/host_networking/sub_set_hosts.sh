#!/bin/bash

. $HOME/workspace/work/openstack/config/openstack_exported.var
function sub_set_hosts(){
	local host_name=
#	option handling
   for o in $@
   do
      case $o in
         --help*)
				cat <<-HELP
				usage: $0 --host_name=<host name>
				note: please refer to:
				$openstack_hosts_conf
				HELP
         ;;
			--host_name=*)
				host_name="${o#*=}"
				#set host name
				sudo hostnamectl set-hostname $host_name
				#set hosts file
				sudo cp /etc/hosts /etc/hosts.bak	#back up the original
				sudo echo "# (BEGIN) added for openstack" >> /etc/hosts
				sudo ./hosts.sh >> /etc/hosts
				sudo echo "# (END)" >> /etc/hosts
			;;				
<<<<<<< HEAD
      

=======
      esac
>>>>>>> 6fa23f944ec91148f1b49cbbc4af0b34a811e558
   done
	
		
	case $host_name in


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

<<<<<<< HEAD
sub_set_hosts $@
=======
>>>>>>> 6fa23f944ec91148f1b49cbbc4af0b34a811e558