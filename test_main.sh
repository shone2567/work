#!/bin/bash


main(){

	if [ $# -ne 1 ]; then
		echo "####################################"
		echo "Usage : $0 Deploy Option"
		echo "Please check $0 --help"
		exit 1
	fi
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

	
	echo "Check environment status"
		
        #only two nodes for now will add more nodes later

	HOSTS="10.0.0.31 10.0.0.11"  

	compute1="10.0.0.31"
	controller="10.0.0.11"
	COUNT=4
	for myHost in $HOSTS
	do
  		count=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
  		if [ $count -eq 0 ]; then
    		# 100% failed
    			echo "Host : $myHost is down (ping failed) at $(date)"
			exit 1
 	        else
   			echo "Host : $myHost is alive"

  		fi
	done

	#check installed packages
        
	if yum -q list installed centos-release-openstack-mitaka &>/dev/null; then
        	echo "Openstack Packages already installed pass eviroment setup"
	else
        	echo "Openstack packages is not installed. Start installing "
		echo "Setting up controller environment"
		$DIR/environment_setup/controller_setup.sh &> "controller_setup.log" &
		echo "Finished"
		echo "Setting up compute environment"

	#scp enviroment file to compute1
			
		ssh_setup $compute1
	        scp ssh_key_auth.sh compute1_setup.sh root@"$compute1":~
		ssh root@$compute1 '~/compute_setup.sh' &>> "$compute1""_setup.log"
		echo "Finished environment setup"
		 
	fi

	echo "Finished enviroment setup"
        read
	case $1 in
	--help*)
		cat <<-HELP
		#    OpenStack multinode deployment tool
		#-----------------------------------------------------
		#    Option 1:
		#
		#    Deploy Keystone, Glance, Compute and Neutron
		#
		#    Option 2:
		#    
		#    Deploy Keystone, Glance, Compute, Neutron and Horizon
		#
		#    Option 3;
		#
		#    Deploy Option2 and add Swift
		#
		#    example:
		#    ./main 1   <-- deploy option 1
		#
		HELP
	exit
	;;
		1) echo "###        Deploy Option1       ###"
		   echo "##################################################"
		   #echo "install keystone"
		   $DIR/identity_service/init.sh &> "keystone_install.log" &
       		   spinner $! "Keystone Service"
		   echo ""
		   #echo "install glance"
		   $DIR/glance_service/init.sh &> "glance_install.log" &
       		   spinner $! "Glance Service"
		   echo ""
                   #echo "install compute
                   $DIR/compute_service/init.sh &> "compute_install.log" &
       		   spinner $! "Compute Service"
		   echo ""
       		   #echo "install neutron"
		   $DIR/networking_service/init_selfservice.sh &> "neutron_install.log" &
       		   spinner $! "Neutron Service"
		   echo " "
		   echo "Depolyment Finished"
		;;
		2)
 	           echo "###        Deploy Option2      ###"
		   echo "##################################################"
		   echo "install keystone"
		   /root/work/identity_service/init.sh
       		   echo "install glance"
         	   /root/work/glance_service/init.sh
                   echo "install compute"
                   /root/work/compute_service/init.sh
       		   echo "install neutron"
	           /root/work/networking_service/init.sh 	
		   echo "install horizon"
		   /root/work/horizon_service/init.sh
		;;
		3)
		   echo "###       Deploy Option3       ###"
		   echo "##################################################"
		   echo "install keystone"
		   /root/work/identity_service/init.sh
       		   echo "install glance"
         	   /root/work/glance_service/init.sh
                   echo "install compute"
                   /root/work/compute_service/init.sh
       		   echo "install neutron"
	           /root/work/networking_service/init.sh 
		   echo "install horizon"
	   	   /root/work/horizon_service/init.sh
		   echo "install swift"
		   /root/work/swift_service/init.sh
		;;
		*)
		   echo "Option $1 is invailded"
		esac
}

spinner()
{
	local pid=$1
	local delay=0.55
	local spinstr='|/-\'
	echo -n "Installing $2 ......."
	while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        	local temp=${spinstr#?}
        	printf " [%c]  " "$spinstr"
        	local spinstr=$temp${spinstr%"$temp"}
        	sleep $delay
        	printf "\b\b\b\b\b\b"
    	done
	printf "    \b\b\b\b"
}

ssh_setup()
{
	if [ ! -f ~/.ssh/id_rsa ]; then
        	echo "start connection"
        	mkdir ~/.ssh
        	chmod 700 ~/.ssh
        	ssh-keygen -f id_rsa -t rsa -N ''
        	cp id_rsa id_rsa.pub "/root/.ssh/"
        	rm -f id_rsa id_rsa.pub
	else
        	echo "already have rsa keys"
	fi

	node_ip=$1
	./ssh_key_auth.sh "$node_ip"

}


main "$@"



exit 0
