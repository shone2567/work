#!/bin/bash

sub_ls_diskinfo_to_array(){
	local disk_dir="$(pwd)"
	local disk_filter="*\.vdisk"
	declare -a disk_array;
	disk_array=($(ls $disk_dir | grep -E "$disk_filter"))
	echo "${disk_array[*]}"
}

#test output
sub_ls_diskinfo_to_array


