#!/bin/bash
function generate_ssh_key(){
        IFS=$'\n' read -d '' -r -a nodes < object_storage_nodes
        mkdir ~/.ssh
        chmod 700 ~/.ssh
        ssh-keygen -f id_rsa -t rsa -N ''
        cp id_rsa id_rsa.pub "/root/.ssh/"
        rm -f id_rsa id_rsa.pub
}

function setup_ssh(){
	if [ -f ssh_key_auth.sh ]; then
		echo "start connection"
		./ssh_key_auth.sh $1
	else
		echo "Need ssh_key_auth.sh file"
	fi
}
