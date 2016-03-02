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
sub_mkdummydisk(){

local disk_count=$1
local disk_size="64m" #64MB - ZFS minimum disk size
local disk_dir=$(pwd)
local disk_name_prefix="vdisk"
declare -a disk_name_array #declare array (this is local var by default.
	for ((i=0; i < $disk_count; i++)){

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
	} #for loop 
	return 0

}

#testing
sub_mkdummydisk 6 #creatign 6 vdisk...
