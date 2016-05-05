#!/bin/bash

#. $HOME/workspace/work/openstack/config/openstack_exported.var
sub_network_device_survey() {
	local seq=
	local profile=
	local dev=
	local ip4=
	local method=
	local mac=
	local up=
	#local seqs=($(ip -o a | grep "inet " | sed "s/ /:/g" | cut -d ":" -f 1))

	#echo "${seqs[0]}"
	#echo "${seqs[@]}"
	
	local device_list=($( nmcli d s | sed "1d" | sed -E "s/[ ]+/|/g" | cut -d "|" -f 1))
	#for seq in ${seqs[@]}
	for dev in ${device_list[@]}
	do
		profile=$(ip -o a | grep -E "$dev[ ]+inet[ ]" | sed "s/ /:/g")
		seq=$(echo $profile | cut -d ":" -f 1)
		ip4=$(echo $profile | cut -d ":" -f 8)
		method=$(echo $profile | sed -E -n "s/.+(dynamic)+.+/\1/p" | sed -E "s/dynamic/auto/")
		mac=$(ip -o l | grep -E "$dev" | sed -E "s/link\/[[:alnum:]]+[ ]/|/" | cut -d "|" -f 2 | sed -E "s/ brd /|/" | cut -d "|" -f 1)
		up=$(ip -o a | grep -E "$dev.*inet " | wc -l)
		echo "$dev,$seq,$ip4,$method,$mac,$up"
	done 
	
}
sub_network_device_survey $@

