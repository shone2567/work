#!/bin/bash

#. $HOME/workspace/work/openstack/config/openstack_exported.var
sub() {
	local seq=
	local profile=
	local dev=
	local ip4=
	local method=
	local mac=
	local seqs=($(ip -o a | grep "inet " | sed "s/ /:/g" | cut -d ":" -f 1))

	#echo "${seqs[0]}"
	#echo "${seqs[@]}"
	
	for seq in ${seqs[@]}
	do
		#echo "seq: $seq"
		profile=$(ip -o a | grep -E "^$seq:.+inet " | sed "s/ /:/g")
		#echo "profile: $profile"			
		dev=$(echo $profile | cut -d ":" -f 3)
		ip4=$(echo $profile | cut -d ":" -f 8)
		method=$(echo $profile | sed -E -n "s/.+(dynamic)+.+/\1/p" | sed -E "s/dynamic/auto/")
		mac=$(ip -o l | grep -E "^$seq:" | sed -E "s/link\/[[:alnum:]]+[ ]/|/" | cut -d "|" -f 2 | sed -E "s/ brd /|/" | cut -d "|" -f 1)
		echo "$seq,$dev,$ip4,$method,$mac"
	done 
	
}
sub $@

