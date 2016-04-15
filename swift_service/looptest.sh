#!/bin/bash


IFS=$'\n' read -d '' -r -a nodes < object_storage_nodes
for node_info in "${nodes[@]}"
do
	node_ip=$(echo "$node_info" | cut -d " " -f1)	
	declare node_$node_ip=$node_ip
#	echo "$node_ip"
	varname=node_"$node_ip"
	echo ${!varname}
	echo ${varname}
done



