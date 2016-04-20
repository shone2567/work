#!/bin/bash

function generate_ssh_key(){
	IFS=$'\n' read -d '' -r -a nodes < object_storage_nodes
	mkdir ~/.ssh
	chmod 700 ~/.ssh
	ssh-keygen -f id_rsa -t rsa -N ''
	cp id_rsa id_rsa.pub "/root/.ssh/"
	rm -f id_rsa id_rsa.pub
}


generate_ssh_key	
IFS=$'\n' read -d '' -r -a nodes < object_storage_nodes
for node_info in ${nodes[*]}
do
	node_ip=$(echo $node_info | cut -d " " -f2)
	./ssh_key_auth.sh $node_ip
	scp ssh_key_auth.sh storage_init.sh root@$node_ip:~
	ssh root@$node_ip '~/storage_init.sh' &>> "$node_ip""_output" &
done



