#!/bin/bash

sub_zpool_create(){

	local raid_type="raidz2" 
	local disk_dir=$HOME"/temp/zfs"
	local disk_filter="*\.vdisk"
	local log_filter="*\.vlog"
	local cache_filter="*\.vcache"

	local zpool="pool1"
	declare -a disk_array
	declare -a log_array
	declare -a cache_array

	disk_array=( $(find $disk_dir | grep -E "$disk_filter") )
	log_array=( $(find $disk_dir | grep -E "$log_filter") )
	cache_array=( $(find $disk_dir | grep -E "$cache_filter") )
	
	#Zpool creation
	sudo zpool create $zpool $raid_type ${disk_array[*]}
	#add log (write cache) - no raid allowed...
	sudo zpool add $zpool log mirror ${log_array[*]}
	#add cache (read cache)
	sudo zpool add $zpool cache ${cache_array[*]}
	#view zpool list
	sudo zpool list
	#view zpool status
	sudo zpool status
	
}

#test output
sub_zpool_create
