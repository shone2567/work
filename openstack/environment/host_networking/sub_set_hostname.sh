#!/bin/bash


sub_set_hostname(){
	if [ "$#" -eq 0 ]; then
		exit 1
	fi
	local hostname=$1
	sudo hostnamectl set-hostname $hostname
}

