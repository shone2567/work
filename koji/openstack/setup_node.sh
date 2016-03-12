
#!/bin/bash


HOSTNAME=
IF_1_BOOTPROT=static				#static or dhcp	
IF_1_IPADDR=x.x.x.x				#required if static
IF_1_NETMASK=255.255.255.0
IF_1_NAME=ethxxx
IF_1_ONBOOT=yes

main(){

	#sub_set_hostname $HOSTNAME
	sub_set_hosts
	sub_set_ifcfg_mgmt
	sub_set_ifcfg_pub

	
}

sub_set_hostname(){
	if [ "$#" -eq 0 ]; then
		exit 1
	fi
	local hostname=$1
	sudo hostnamectl set-hostname $hostname
}

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
sub_set_ifcfg(){
	local macaddress=
	#get all nic interface name
	declare -a ifs=( `ip -o link | grep -e "^...eno*" | cut -d " " -f 2 | cut -d ":" -f 1` )

	for iface in ${ifs[*]}; do
     	#get mac address based on interface name
     	macaddress=`ip -o link | grep -e "$iface" | cut -d " " -f 18`
     	echo -e "$iface\t$macaddress"
		#check if the cfg file exist:
		if [  ]; then

		else

		fi	
	done

}

sub_set_ifcfg_mgmt(){

	#	need to config following 2 config files:
	#	/etc/sysconfig/network (TBD)
	#	/etc/sysconfig/network-scripts/ifcfg-xxx
	#	HWADDR=<mac address>
	#	BOOTPROT=static
	#	IPADDR=x.x.x.x
	#	NETMASK=255.255.255.0
	#	NAME=ethxxx
	#	ONBOOT=yes
	local target_dir=/etc/sysconfig/network-scripts
	local target_file_prefix=ifcfg-
	local hwaddr=
	local bootprot=static
	local ipaddr=x.x.x.x
	local netmask=255.255.255.0
	local name=
	local onboot=yes

	exit 0

}

sub_set_ifcfg_pub(){
	local name=					#interface name
	local type=Ethernet
	local onboot=yes
	local bootproto=none	

}


main $@
