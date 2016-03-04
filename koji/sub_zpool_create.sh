#!/bin/bash

sub_zpool_create(){

	local raid_type="raidz2" 
	local disk_dir="$(pwd)"
	local disk_filter="*\.vdisk"
	local zpool="pool1"
	declare -a disk_array
	disk_array=( $(find $disk_dir | grep -E "$disk_filter") )
	
	#Zpool creation
	sudo zpool create $zpool $raid_type ${disk_array[*]}
	#view zpool list
	sudo zpool list
	#view zpool status
	sudo zpool status
	
}

#test output
sub_zpool_create
