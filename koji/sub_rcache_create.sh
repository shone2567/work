#!/bin/bash

#   
# Script/Function Name:
#
# Version:
#
# Author:
# 
# File Requirement:
# none
#
# Description:
# It will create numbers of virtual disk and formatted as GPT for ZFS vdev 
# creation purpose. 
# 
# Parameters:
#  Inputs:
#
#  Ouputs:
#   Standard Output:
#   
#
sub_rcache_create(){

local disk_count=$1
local disk_size="128m" #64MB - ZFS minimum disk size

local disk_dir=$HOME"/temp/zfs/vcaches"

local disk_prefix="" #add prefix in case needed
local disk_postfix="vcache"
#local disk_list_info="${disk_postfix}.info"

declare -a disk_name_array #declare array (this is local var by default.
        if [ ! -d $disk_dir ]; then
           mkdir -p $disk_dir #-p will automatically create parent directory if not exist
        fi


	for ((i=0; i < $disk_count; i++)){

	local timestamp=`date "+%s"`
	#disk_name_array[i]=$disk_dir/$disk_prefix$timestamp$i"."$disk_postfix
	disk_name_array[i]=$disk_dir/$disk_prefix$i"."$disk_postfix
	sudo head -c $disk_size /dev/zero > ${disk_name_array[i]}
	chmod 666 ${disk_name_array[i]}
	#note 1: placing - after less tans (below) at here document will ignore 
	#the tab indentation for code readability.
	#note 2: 2> and 1> can replace with &>
	sudo fdisk ${disk_name_array[i]} &> /dev/null <<-ARG
	g
	p
	w
	ARG
	#echo "${disk_name_array[i]}" >> $disk_list_info
	} #for loop 
	return 0

}

#testing
sub_rcache_create $1
