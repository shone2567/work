#!/bin/bash

. $HOME/work/openstack/config/openstack_exported.var
sub_network_collect(){
	local arg_host_name=
	for o in $@
	do
		case $o in
		--help*)
		cat <<-HELP
		#Script: `$0`
		##Network Device & Connection Summary
		description:
		this command will output network device and connections
		status in following csv format:
		"hostname,device,ipaddr,bitmask,gateway,bootproto,type,state,connection,seq"
		output exmaple:
		---example: start---
		localhost.localdomain,enp0s3,10.0.2.15,24,ethernet,connected,enp0s3,2
		localhost.localdomain,enp0s9,192.168.56.104,24,ethernet,connected,Wired connection 2,4
		localhost.localdomain,enp0s8,,,ethernet,disconnected,,
		localhost.localdomain,lo,127.0.0.1,8,loopback,unmanaged,,1
		---example: end  ---
		HELP
		exit 0
		;;
		esac
	done
	local hostname=
	local connection=
	local device=
	local ip=
	local ipaddr=
	local bitmask=
	local bootproto=
	local deployment=
	local seq=
	local type=
	local state=
	local uuid=
	local ifcfg=

	local ipf_seq=1
	local ipf_ip=7
	
	#declare -a devices=
	#local devices=( $(ip -o a | grep -E "inet " | cut -d ' ' -f 2) ) 
	local devices=( $(nmcli d s | sed -n '1!p' | cut -d ' ' -f 1) ) 
	#echo ${devices[*]}
	for device in ${devices[*]}
	do
		hostname=$(hostname)	
		seq=$(ip -o a | grep -E "${device}.+inet " | cut -d ' ' -f $ipf_seq | cut -d ':' -f 1)	
		type=$(nmcli device status | grep -E "$device" | sed -E "s/[[:blank:]]+/|/g" | cut -d '|' -f 2)
		ip=$(ip -o a | grep -E "$device.+inet " | cut -d ' ' -f $ipf_ip)
		#ip=$(nmcli c s $connection | grep -E "IP4.ADDRESS" | sed -E "s/([ ]|:)+/|/g" | cut -d '|' -f 2)
		ipaddr=$(echo $ip | cut -d '/' -f 1)
		bitmask=$(echo $ip | cut -d '/' -f 2)
		state=$(nmcli device status | grep -E "$device" | sed -E "s/[[:blank:]]+/|/g" | cut -d '|' -f 3)
		connection=$(nmcli c s | grep -E "$device" | sed -E "s/[ ]+([[:alnum:]]+-){4}[[:alnum:]]+[ ]+/|/g" | cut -d '|' -f 1)
		ifcfg=$(ls /etc/sysconfig/network-scripts/ | grep -E "ifcfg-$connection$" | wc -l)
		uuid=$(nmcli c s | grep -E "$connection.*$device" | sed -E "s/.* (([[:alnum:]]+-){4,}[[:alnum:]]+) .*/\1/")
		gateway=$(nmcli c s $connection | grep -E "ipv4.gateway" | sed -E "s/([ ]|:)+/|/g" | cut -d '|' -f 2)
		bootproto=$(nmcli c s $connection | grep -E "DHCP4.OPTION" | sed -n "1p" | cut -d "4" -f 1 | tr '[:upper:]' '[:lower:]')
		echo "$hostname,$device,$ipaddr,$bitmask,$gateway,$bootproto,$type,$state,$connection,$ifcfg,$uuid,$seq"
		
	done

}

sub_network_collect $@
