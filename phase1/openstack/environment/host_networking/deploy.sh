#!/bin/bash

. $HOME/work/openstack/config/openstack_exported.var
#Read Host Status
#Check if connected or not
#Check if dhcp or not
#Check if ifcfg (connection) exisits
sub_main(){
	local o=

	for o in $@
	do
		case $o in
		--help)
		cat <<-HELP
		#Script: $0
		##Title:
		##Description:
		#$0 network down --dev=[device] #not in use
		$0 network survey --dev
		$0 network survey --con
		$0 network survey --ifcfg
		$0 network survey --all
		$0 network down --con=[connection]
		$0 network up --con=[connection]
		$0 network add --con=[connection] --dev=[device]
		$0 network mod static --con=[connection] --ip4=[ipaddr] --mask=24 --gw4=[gateway addr]
		$0 network mod dhcp --con=[connection]
		$0 network del --con=[connection]
		##Requirement:
		##System Impact:
		HELP
		shift
		return 0
		;;
        	esac
	done

	resource=$1; shift; #echo "args: $@"
	action=$1; shift; #echo "args: $@"

	#echo "$resource"
	#echo "$action"

	local dev=
	local con=
	local ip4=
	local mask=
	local gw4=
	
	for o in $@
	do
		case $o in
		--dev*=*)
		dev=${o#*=}
		#shift
		;;
		--con*=*)
		con=${o#*=}
		#shift
		;;
		--ip4=*)
		ip4=${o#*=}
		#shift
		;;
		--mask=*)
		mask=${o#*=}
		#shift
		;;
		--gw4=*)
		gw4=${o#*=}
		#shift
		;;
		esac
	done
	
	case $action in 
		survey)
			#echo "$action in action..."
			sub_network_survey $@
			;;
		down)
			#sub_network_down_by_device $@
			sub_network_down $@ 
			;;
		up)
			sub_network_up $@
			;;
		add)
			sub_network_add $@
			sub_network_up $@
			;;
		mod)
			local directive=$1; shift
			case $directive in
				static)
				sub_network_mod_static4 $@
				sub_network_up $@
				;;
				dhcp)
				sub_network_mod_dhcp4 $@ 
				sub_network_up $@
				;;
			esac
			;;
		del*)
			sub_network_down $@
			sub_network_delete $@
			;;
	esac

	return 0
}

sub_network_survey() {
	local o
	for o in $@
        do
                case "$o" in
                --dev)
		#echo "option: --dev selected"
		./sub_network_device_survey.sh
                shift
                ;;
                --con)
		#echo "option: --con selected"
		./sub_network_connection_survey.sh
                shift
                ;;
                --ifcfg)
		#echo "option: --ifcfg selected"
		./sub_network_ifcfg_survey.sh
                shift
                ;;
		--all|*)
		./sub_network_survey.sh
		;;
                esac
        done
	#echo "end of sub_network_surey"
	return 0


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
		return 0
		;;
		esac
	done

	for o in $@
	do
		case $o in
		--dev*=*)
		device=${o#*=}
		shift
		;;
		esac
	done
	sudo nmcli device disconnect $device	
	return $(echo $?)
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
	return 0
	;;
	esac

	for o in $@
	do
		case $o in
		--con*=*)
		connection=${o#*=}
		shift
		;;
		esac
	done
	sudo nmcli connection up $connection	
	return $(echo $?)
	
}
sub_network_down(){
	local connection=
	for o in $@
	do
		case $o in
		--con*=*)
		connection=${o#*=}
		shift
		;;
		esac
	done
	sudo nmcli connection down $connection	
	return $(echo $?)
	
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
	return $(echo $?)
}

sub_network_mod_static4(){
	local connection=
	local ipv4_method=manual
	local ip4=""
	local gw4=""
	local mask= #bit maskk
	
	local c=0
	for o in $@
	do
		echo "counter: $c"

		case $o in
		--con*=*)
		connection=${o#*=}
		;;
		--ip4=*)
		ip4=${o#*=}
		;;
		--mask=*)
		mask=${o#*=}
		;;
		--gw4=*)
		gw4=${o#*=}
		;;
		esac
		c=`expr $c + 1`
	done
	#sudo nmcli connection mod $connection ipv4.method $ipv4_method ipv4.addresses $ip4 ipv4.gateway $gw4 ipv4.dns 8.8.8.8
	sudo nmcli connection mod $connection ipv4.method $ipv4_method ipv4.addresses $ip4/$mask ipv4.gateway $gw4
	return $(echo $?)

}

sub_network_mod_dhcp4(){
	local connection=
	local ipv4_method=auto
	local ip4=""
	local gw4=""
	
	local c=0
	for o in $@
	do
		#echo "counter: $c"
		case $o in
		--con*=*)
		connection=${o#*=}
		;;
		esac
		c=`expr $c + 1`
	done
	sudo nmcli connection mod $connection ipv4.method "$ipv4_method" ipv4.addresses "$ip4" ipv4.gateway "$gw4"
	return $(echo $?)

}

sub_network_delete(){
	local connection=
	for o in $@
	do
		case $o in
		--con*=*)
		connection=${o#*=}
		;;
		esac
	done
	sudo nmcli connection delete $connection	
	return $(echo $?)
}

sub_main $@
