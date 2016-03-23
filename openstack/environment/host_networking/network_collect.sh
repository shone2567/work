#!/bin/bash

. $HOME/work/openstack/config/openstack_exported.var
sub_network_collect(){
	local arg_host_name=
	for o in $@
	do
		case $o in
		--help*)
			echo "usage: $0 --host_name=<host name>"
		;;
		--host_name=*)
			arg_host_name=${o#*=}	
		;;
	done
}

sub_network_collect $@
