#!/bin/bash

#get all nic interface name
declare -a ifs=( `ip -o link | grep -e "^...eno*" | cut -d " " -f 2 | cut -d ":" -f 1` )

for iface in ${ifs[*]}; do
	#get mac address based on interface name	
	macaddress=`ip -o link | grep -e "$iface" | cut -d " " -f 18`
	echo "$macaddress"
done
