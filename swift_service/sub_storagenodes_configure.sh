#!/bin/bash

IFS=$'\n' read -d '' -r -a nodes < object_storage_nodes

cd ~/.ssh
ssh-keygen -f id_rsa -t rsa -N ''

for node_ip in ${nodes[*]}
do
	./ssh_key_auth.sh $node_ip
	scp storage_init.sh root@$node_ip:~
	ssh root@$node_ip '~/storage_init.sh'
done

