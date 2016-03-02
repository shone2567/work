#!/bin/bash

#   
# Script/Function Name:
#
# Version:
#
# Author:
# 
# File Requirement:
#
#
# Description:
# 
# Effects:
# 
# Parameters:
#  Inputs:
#
#  Ouputs:
#   Standard Output:
#   
#
sub_vdisk_create(){

local disk_count=$1
local disk_size="64m" #64MB - ZFS minimum disk size
local disk_dir=$(pwd)
local disk_name_prefix="vdisk"
local disk_list_info="${disk_name_prefix}.fileinfo"

declare -a disk_name_array #declare array (this is local var by default.

	fr ((i=0; i < $disk_count; i++)){

	local timestamp=`date "+%s"`
	disk_name_array[i]=$disk_dir/$disk_name_prefix$timestamp$i
	sudo head -c $disk_size /dev/zero > ${disk_name_array[i]}
	chmod 666 ${disk_name_array[i]}
	#note: placing - after less tans (below) at here document will ignore 
	#the tab indentation for code readability.
		sudo fdisk ${disk_name_array[i]} <<-ARG
		g
		p
		w
		ARG
	#echo "${disk_name_array[i]}" >> $disk_list_info
	} #for loop 
	return 0

}

#testing
sub_vdisk_create 6 #creatign 6 vdisk...
