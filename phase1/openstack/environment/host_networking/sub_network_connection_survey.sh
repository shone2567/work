#!/bin/bash

#. $HOME/workspace/work/openstack/config/openstack_exported.var
sub_network_connection_survey() {
	
	local conn=
	local uuid=
	local type=
	local dev=
	
	local profile=
	local profile2=
	#local connections=($(nmcli c s | sed -E "s/[ ]+(([[:alnum:]]+-){4,}[[:alnum:]]+)[ ]+/|/" | cut -d "|" -f 1))
	local uuids=( $(nmcli c s | sed -E -n "s/.+[ ]+(([[:alnum:]]+-){4,}[[:alnum:]]+)[ ]+.+/\1/p" ) )

	for uuid in ${uuids[@]}
	do
		#type=$(nmcli c s | grep -E "$conn" | sed -E "s/($conn|[ ]+)/|/g" | cut -d "|" -f 4)
		#dev=$(nmcli c s | grep -E "$conn" | sed -E "s/($conn|[ ]+)/|/g" | cut -d "|" -f 5)
		profile=$(nmcli c s | grep -E "$uuid" | sed -E "s/[ ]+$uuid[ ]+/|/")
		conn=$(echo "$profile" | cut -d "|" -f 1)
		profile2=$(echo "$profile" | cut -d "|" -f 2)
		type=$(echo "$profile2" | cut -d " " -f 1)	
		dev=$(echo "$profile2" | cut -d " " -f 3)
		
		echo "$conn,$uuid,$type,$dev"
		#echo "$conn,$uuid,$type,$dev"
	done

	
}
sub_network_connection_survey $@

