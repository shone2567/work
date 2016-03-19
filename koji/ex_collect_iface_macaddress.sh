#!/bin/bash
iface=
#get all nic interface name
declare -a ifs=( `ip -o link | grep -e "^...eno*" | cut -d " " -f 2 | cut -d ":" -f 1` )

for iface in ${ifs[*]}; do
	ipaddr=$(ip -o address | grep -E "$iface( )+inet( )+" | sed -e "s/ /|/g" | cut -d "|" -f 7 | cut -d "/" -f 1)
	hwaddr=$(ip -o link | grep -e "$iface" | cut -d " " -f 18)

	echo -e "$iface\t$ipaddr\t$hwaddr"

done

echo -e "arg count:	$#"
