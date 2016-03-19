#!/bin/bash
. config/openstack_export.var

main(){
	echo "main()"
	#sub_set_hostname $HOSTNAME
	#sub_set_hosts
	#sub_set_ifcfg

	
}

#. sub_set_hostname.sh
#. sub_set_hosts.sh
#. sub_set_ifcfg.sh


main $@
