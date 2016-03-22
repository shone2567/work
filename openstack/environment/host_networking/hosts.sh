#!/bin/bash
. $HOME/workspace/work/openstack/config/openstack_exported.var

function hosts(){

	declare -a hosts=$(cat $openstack_hosts_conf | cut -d "," -f 1)
	local connection=mgmt
	for host in $hosts
	do
		declare -a ipaddr=$(cat $openstack_network_conf | grep -E "${host}.*$connection" | cut -d "," -f 4)
		echo -e "${host}\t${ipaddr}"
	done
}

hosts $@
