#!/bin/bash


sub_create_ifcfg(){
	local ifcfg_path=/etc/sysconfig/network-scripts/ifcfg-
	#local ifcfg_path=./ifcfg-
	local ifcfg_file=
	local device=
	local hwaddr=
	local bootprot=static
	local ipaddr=
	local netmask=255.255.255.0
	local gateway=
	local type=Ethernet
	local name=
	local onboot=yes

	if [ ${#@} -eq 0 ]; then #if no argument
		cat <<- ERR
			error: usage $0 --<option>=<option value>
			<option>:
			--device=<eth>
			--ipaddr=<ip address>
			--netmask=<netmask>
			--gateway=<gateway>
			--type=Ethernet
			--name=<the same as device value>
			--bootproto=<none|static|dhcp|bootp>
			--hwaddr=<mac address>
			--onboot=<yes|no>			
		ERR
		exit 1
	fi

	for i in $@
	do
		case $i in
			--device=*)
			device="${i#*=}"
			ifcfg_file=$ifcfg_path$device
			#if ifcfg_file already exist, then back it up.
			if [ -f $ifcfg_file ]; then
				mv $ifcfg_file $ifcfg_file.bak.$(date "+%s") 
			fi
			echo "DEVICE=$device" >> $ifcfg_file
			#shift
			;;
			--ipaddr=*)
			ipaddr="${i#*=}"
			echo "IPADDR=$ipaddr" >> $ifcfg_file
			#shift
			;;
			--netmask=*)
			netmask="${i#*=}"
			echo "NETMASK=$netmask" >> $ifcfg_file
			#shift
			;;
			--gateway=*)
			gateway="${i#*=}"
			echo "GATEWAY=$gateway" >> $ifcfg_file
			#shift
			;;
			--type=*)
			type="${i#*=}"
			echo "TYPE=$type" >> $ifcfg_file
			#shift
			;;
			--name=*)
			name="${i#*=}"
			echo "NAME=$name" >> $ifcfg_file
			#shift
			;;
			--bootproto=*)
			bootproto="${i#*=}"
			echo "BOOTPROTO=$bootproto" >> $ifcfg_file
			#shift
			;;
			--hwaddr=*)
			hwaddr="${i#*=}"
			echo "HWADDR=$hwaddr" >> $ifcfg_file
			#shift
			;;
			--onboot=*)
			onboot="${i#*=}"
			echo "ONBOOT=$onboot" >> $ifcfg_file
			#shift
			;;
			--userctl=*)
			userctl="${i#*=}"
			echo "USERCTL=$userctl" >> $ifcfg_file
			;;
			*=*)
				#unknown option
			;;
		esac
	done
	if [ -z ${device+x} ]; then	#if $device is unset 
		echo "error: usage $0 --device=<device>"
		rm $ifcfg_file
		exit 1
	elif [ ${#device} -eq 0 ]; then #if $device is empty string (length = 0)
		echo "error: usage $0 --device=<device> (2)"
		rm $ifcfg_file
		exit 1 
	fi
	echo "file: $ifcfg_file"
	exit 0
}
#sub_create_ifcfg $@

