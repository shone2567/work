#!/bin/bash

. $HOME/work/openstack/config/openstack_exported.var
sub_network_collect(){
	local arg_host_name=
	for o in $@
	do
		case $o in
		--help*)
		cat <<-HELP
		#Script: $0
		##Network Device & Connection Summary
		description:
		this command will output network device and connections
		status in following csv format:
		"hostname,device,ipaddr,bitmask,type,state,connection,seq"
		HELP
		exit 0
		;;
		esac
	done
	local hostname=
	local connection=
	local device=
	local ipaddr=
	local bitmask=
	local bootproto=yes
	local deployment=auto
	local seq=0
	local type=
	local state=

	local ipf_seq=1
	local ipf_ip=7
	
	#declare -a devices=
	local devices=( $(ip -o a | grep -E "inet " | cut -d ' ' -f 2) ) 
	#echo ${devices[*]}
	for device in ${devices[*]}
	do
		hostname=$(hostname)	
		seq=$(ip -o a | grep -E "${device}.+inet " | cut -d ' ' -f $ipf_seq | cut -d ':' -f 1)	
		local ip=$(ip -o a | grep -E "$device.+inet " | cut -d ' ' -f $ipf_ip)	
		ipaddr=$(echo $ip | cut -d '/' -f 1)
		bitmask=$(echo $ip | cut -d '/' -f 2)
		
		type=$(nmcli device status | grep -E "$device" | sed -E "s/[[:blank:]]+/|/g" | cut -d '|' -f 2)
		state=$(nmcli device status | grep -E "$device" | sed -E "s/[[:blank:]]+/|/g" | cut -d '|' -f 3)
		connection=$(nmcli c s | grep -E "$device" | sed -E "s/[ ]+([[:alnum:]]+-){4}[[:alnum:]]+[ ]+/|/g" | cut -d '|' -f 1)
		echo "$hostname,$device,$ipaddr,$bitmask,$type,$state,$connection,$seq"
		
	done

}

sub_network_collect $@
