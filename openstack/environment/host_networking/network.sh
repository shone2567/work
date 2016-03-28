#!/bin/bash

. $HOME/work/openstack/config/openstack_exported.var
#Read Host Status
#Check if connected or not
#Check if dhcp or not
#Check if ifcfg (connection) exisits
sub_main(){

	resource=$1; shift; echo "args: $@"
	action=$1; shift; echo "args: $@"

	echo "$resource"
	echo "$action"
	
	case $action in 
		down)
			#sub_network_down_by_device $@
			sub_network_down $@ 
			;;
		up)
			sub_network_up $@
			;;
		add)
			sub_network_add $@
			;;
		mod)
			local directive=$1; shift
			case $directive in
				static)
				sub_network_mod_static4 $@
				;;
				dhcp)
				sub_network_mod_dhcp4 $@ 
				;;
			esac
			;;
		del*)
			sub_network_delete $@
			;;
	esac

	for o in $@
	do
		case $o in
		--help)
		cat <<-HELP
		#Script: $0
		##Title:
		##Description:
		$0 network down --device=[device]
		$0 network down --connection=[connection]
		$0 network up --connection=[connection]
		$0 network add --connection=[connection] --device=[device]
		$0 network mod static --connection=[connection] --ip4=[ipaddr/mask] --gw4=[gateway addr]
		$0 network mod dhcp --connection=[connection]
		$0 network del --connection=[connection]
		##Requirement:
		##System Impact:
		HELP
		exit 0
		;;
        	esac
	done

	exit 0
}


sub_network_down_by_device() {
	local device=

	for o in $@
	do
		case $o in
		--help)
		cat <<-HELP
		#Script: $0
		##Title:
		##Description:
		--device=[device]
		##Requirement:
		##System Impact:
		HELP
		exit 0
		;;
		esac
	done

	for o in $@
	do
		case $o in
		--device=*)
		device=${o#*=}
		shift
		;;
		esac
	done
	sudo nmcli device disconnect $device	
	exit $(echo $?)
}

sub_network_up(){
	local connection=
	case $o in
	--help)
	cat <<-HELP
	#Script: $0
	##Title:
	##Description:
	--device=[device]
	##Requirement:
	##System Impact:
	HELP
	exit 0
	;;
	esac

	for o in $@
	do
		case $o in
		--connection=*)
		connection=${o#*=}
		shift
		;;
		esac
	done
	sudo nmcli connection up $connection	
	exit $(echo $?)
	
}
sub_network_down(){
	local connection=
	for o in $@
	do
		case $o in
		--connection=*)
		connection=${o#*=}
		shift
		;;
		esac
	done
	sudo nmcli connection down $connection	
	exit $(echo $?)
	
}

sub_network_add(){
	local connection=
	local device=
	local type=ethernet
	#local ipaddr=
	#local bitmask=
	#local gateway=
	
	local c=0
	for o in $@
	do
		echo "counter: $c"

		case $o in
		--con*=*)
		connection=${o#*=}
		;;
		--dev*=*)
		device=${o#*=}
		;;
		esac
		c=`expr $c + 1`
	done
	sudo nmcli connection add type ethernet con-name $connection ifname $device	
	exit $(echo $?)
}

sub_network_mod_static4(){
	local connection=
	local ipv4_method=manual
	local ip4=""
	local gw4=""
	
	local c=0
	for o in $@
	do
		echo "counter: $c"

		case $o in
		--connection=*)
		connection=${o#*=}
		;;
		--ip4=*)
		ip4=${o#*=}
		;;
		--gw4=*)
		gw4=${o#*=}
		;;
		esac
		c=`expr $c + 1`
	done
	#sudo nmcli connection mod $connection ipv4.method $ipv4_method ipv4.addresses $ip4 ipv4.gateway $gw4 ipv4.dns 8.8.8.8
	sudo nmcli connection mod $connection ipv4.method $ipv4_method ipv4.addresses $ip4 ipv4.gateway $gw4
	exit $(echo $?)

}

sub_network_mod_dhcp4(){
	local connection=
	local ipv4_method=auto
	local ip4=""
	local gw4=""
	
	local c=0
	for o in $@
	do
		echo "counter: $c"

		case $o in
		--connection=*)
		connection=${o#*=}
		;;
		esac
		c=`expr $c + 1`
	done
	sudo nmcli connection mod $connection ipv4.method $ipv4_method ipv4.addresses $ip4 ipv4.gateway $gw4
	exit $(echo $?)

}

sub_network_delete(){
	local connection=
	for o in $@
	do
		case $o in
		--connection=*)
		connection=${o#*=}
		;;
		esac
	done
	sudo nmcli connection delete $connection	
	exit $(echo $?)
}

sub_main $@
