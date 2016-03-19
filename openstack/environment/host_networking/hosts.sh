#!/bin/bash
. $HOME/workspace/work/openstack/config/openstack_exported.var

function hosts(){

	declare -a hosts=$(cat $openstack_hosts_conf | cut -d "," -f 1)
	local network_type=internal
	for host in $hosts
	do
		declare -a ipaddr=$(cat $openstack_network_conf | grep -E "${host}.*$network_type" | cut -d "," -f 4)
		echo -e "${host}\t${ipaddr}"
	done
}

hosts $@
