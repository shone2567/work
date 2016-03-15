#!/bin/bash


sub_create_ifcfg(){
	#local ifcfg_path=/etc/sysconfig/network-scripts/ifcfg-
	local ifcfg_path=./ifcfg-
	local ifcfg_file=
	local device=
	local hwaddr=
	local bootprot=static
	local ipaddr=
	local netmask=255.255.255.0
	local gateway=
	local name=
	local onboot=yes

	if [ ${#@} -eq 0 ]; then #if no argument
		cat <<- ERR
			error: usage $0 --<option>=<option value>
			<option>:
			--device=
			--ipaddr=
			--netmask=
			--gateway=
			--type=Ethernet
			--name=
			--bootproto=
			--hwaddr=
			--onboot=			
		ERR
		exit 0
	elif [ -z ${device+x} ]; then	#if $device is unset 
		echo "error: usage $0 --device=<device>"
		exit 0
	elif [ ${#device} -eq 0 ]; then #if $device is empty string (length = 0)
		echo "error: usage $0 --device=<device> (2)"
		exit 0
	fi

	for i in $@
	do
		case $i in
			--device=*)
			device="${i#*=}"
			ifcfg_file=$ifcfg_path$device
			echo "DEVICE=$device" >> $ifcfg_file
			shift
			;;
			--ipaddr=*)
			ipaddr="${i#*=}"
			shift
			;;
			--netmask=*)
			netmask="${i#*=}"
			shift
			;;
			--gateway=*)
			gateway="${i#*=}"
			shift
			;;
			--type=*)
			type="${i#*=}"
			shift
			;;
			--name=*)
			name="${i#*=}"
			shift
			;;
			--bootproto=*)
			bootproto="${i#*=}"
			shift
			;;
			--hwaddr=*)
			hwaddr="${i#*=}"
			shift
			;;
			--onboot=*)
			onboot="${i#*=}"
			shift
			;;
			*=*)
				#unknown option
			;;
		esac
	done
	echo "file: $ifcfg_file"
	cat <<-CFG > $ifcfg_file
		DEVICE=$device
		IPADDR=$ipaddr
		NETMASK=$netmask
		GATEWAY=$gateway
		TYPE=$type
		NAME=$name
		BOOTPROTO=$bootproto
		HWADDR=$hwaddr
		ONBOOT=$onboot

	CFG
}
sub_create_ifcfg $@

