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
sub_vdisk_create(){

local disk_count=$1
local disk_size="64m" #64MB - ZFS minimum disk size
local disk_dir=$(pwd)
local disk_prefix="" #add prefix in case needed
local disk_postfix="vdisk"
#local disk_list_info="${disk_postfix}.info"

declare -a disk_name_array #declare array (this is local var by default.

	for ((i=0; i < $disk_count; i++)){

	local timestamp=`date "+%s"`
	disk_name_array[i]=$disk_dir/$disk_prefix$timestamp$i"."$disk_postfix
	sudo head -c $disk_size /dev/zero > ${disk_name_array[i]}
	chmod 666 ${disk_name_array[i]}
	#note 1: placing - after less tans (below) at here document will ignore 
	#the tab indentation for code readability.
	#note 2: 2> and 1> can replace with &>
	#sudo fdisk ${disk_name_array[i]} &> /dev/null <<-ARG
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
sub_vdisk_create 6 #creating 6 vdisk...
