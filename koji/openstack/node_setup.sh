#!/bin/bash
declare -a nodes
declare -A controller
declare -A compute1
declare -A compute2
declare -A storage1
declare -A storage2


hostname


main(){

}

sub_set_hostname(){
	if [ "$#" -eq 0 ]; then
		exit 1
	fi
	local hostname=$1
	sudo hostnamectl set-hostname $hostname
}

sub_set_ifcfg(){
	#	need to config following 2 config files:
	#	/etc/sysconfig/network (TBD)
	#	/etc/sysconfig/network-scripts/ifcfg-xxx
	#	HWADDR=<mac address>
	#	BOOTPROT=static
	#	IPADDR=x.x.x.x
	#	NETMASK=255.255.255.0
	#	NAME=ethxxx
	#	ONBOOT=yes
	
}



main $@
