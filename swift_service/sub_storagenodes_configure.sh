#!/bin/bash


function ssh_au {
ssh-keygen -t rsa -N ""
ssh-copy-id root@$1
}

IFS=$'\n' read -d '' -r -a nodes < object_storage_nodes

for node_ip in ${nodes[*]}
do
	ssh_au $node_ip
	scp storage_init.sh root@$node_ip:~
	ssh root@$node_ip '~/storage_init.sh'
done

