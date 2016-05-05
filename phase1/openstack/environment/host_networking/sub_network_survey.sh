#!/bin/bash

#. $HOME/workspace/work/openstack/config/openstack_exported.var
sub_network_survey() {
	local dev_list=$(./sub_network_device_survey.sh)
	local con_list=$(./sub_network_connection_survey.sh)
	local cfg_list=$(./sub_network_ifcfg_survey.sh)
	
	local dev_line=
	local con_line=
	local cfg_line=
	local con=
	#echo "cfg_list:"
	#echo "$cfg_list"
	local devs=($(echo "$dev_list" | cut -d "," -f 1))
	for dev in ${devs[@]}
	do
		dev_line=$(echo "$dev_list" | grep "$dev")	
		con_line=$(echo "$con_list" | grep "$dev")
		con=$(echo $con_line | cut -d "," -f 1)
		uuid=$(echo $con_line | cut -d "," -f 2)
		type=$(echo $con_line | cut -d "," -f 3)
		#echo "con: $con"
		cfg_line=$(echo "$cfg_list" | grep -E "^$con.+$dev")
		echo "cfg line: $cfg_line"
		ifcfg=$(echo $cfg_line | cut -d "," -f 2)
		
		echo "$dev_line,x,$con,$uuid,$type,$ifcfg"
	done	
}
sub_network_survey $@
