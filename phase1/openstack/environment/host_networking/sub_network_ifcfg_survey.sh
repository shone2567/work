#!/bin/bash

#. $HOME/workspace/work/openstack/config/openstack_exported.var
sub_network_ifcfg_survey() {
	
	local uuids=( $(nmcli c s | sed -E -n "s/.+[ ]+(([[:alnum:]]+-){4,}[[:alnum:]]+)[ ]+.+/\1/p" ) )
	local ifcfg=
	local profile=
	local profile2=
	local dev=

	for uuid in ${uuids[@]}
	do
		#type=$(nmcli c s | grep -E "$conn" | sed -E "s/($conn|[ ]+)/|/g" | cut -d "|" -f 4)
		#dev=$(nmcli c s | grep -E "$conn" | sed -E "s/($conn|[ ]+)/|/g" | cut -d "|" -f 5)
		profile=$(nmcli c s | grep -E "$uuid" | sed -E "s/[ ]+$uuid[ ]+/|/")
		conn=$(echo "$profile" | cut -d "|" -f 1)
		dev=$(echo "$profile" | cut -d "|" -f 2 | sed -E "s/[ ]+/|/" | cut -d "|" -f 2)
		ifcfg=$(ls /etc/sysconfig/network-scripts | grep -E "ifcfg-$conn$" | wc -l)
			
		echo "$conn,$ifcfg,$dev"
		#echo "$conn,$uuid,$type,$dev"
	done

	
}
sub_network_ifcfg_survey $@

