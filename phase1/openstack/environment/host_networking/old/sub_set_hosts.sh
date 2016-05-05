#!/bin/bash

sub_set_hosts(){
	#local target_file=/etc/hosts
	local target_file=test_hosts.temp
	declare -a controller_ipaddr=("10.0.0.11")
	declare -a compute_ipaddr=("10.0.0.31")
	declare -a blkstorage_ipaddr=("10.0.0.41")
	declare -a objstorage_ipaddr=("10.0.0.51" "10.0.0.52")
	local controller_hostname="controller"
	local compute_hostname="compute"
	local blkstorage_hostname="block"
	local objstorage_hostname="object"
	local format="%s\t%s\n"
	if [ -e $target_file ]; then
		sudo cp $target_file $target_file.bak.`date +"%s"`
	fi

	printf $format "127.0.0.1" "localhost localhost.localdomain" > $target_file

	local c

	c=0	
	for ip in ${controller_ipaddr[@]}
	do
		printf $format $ip "$controller_hostname$c" >> $target_file
		c=`expr $c + 1`
	done 
	
	c=0	
	for ip in ${compute_ipaddr[@]}
	do
		printf $format $ip "$compute_hostname$c" >> $target_file
		c=`expr $c + 1`
	done 

	c=0	
	for ip in ${blkstorage_ipaddr[@]}
	do
		printf $format $ip "$blkstorage_hostname$c" >> $target_file
		c=`expr $c + 1`
	done 

	c=0	
	for ip in ${objstorage_ipaddr[@]}
	do
		printf $format $ip "$objstorage_hostname$c" >> $target_file
		c=`expr $c + 1`
	done 

	exit 0

}
