#!/bin/bash
sub_zvol_create(){

	local zpool="pool1"
	local zvol_prefix="zvol"
	local zvol_quota="10M"
	
	for (( i=1; i <= 3; i++ )){ 
		sudo zfs create -o quota=$zvol_quota ${zpool}/${zvol_prefix}$i
	}

	sudo zfs list

}

sub_zvol_create
