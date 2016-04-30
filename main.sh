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
		
        #Set node number based on deploy option

	if [ $1 -eq 3 ]; then

		HOSTS="10.0.0.31 10.0.0.11 10.0.0.51 10.0.0.52"

	else

	  	HOSTS="10.0.0.31 10.0.0.11"

	fi
	
	compute1="10.0.0.31"
	controller="10.0.0.11"
	object1="10.0.0.51"
	object2="10.0.0.52"
	COUNT=4
	for myHost in $HOSTS
	do
  		count=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
  		if [ $count -eq 0 ]; then
    		# 100% failed
    			echo "Host : $myHost is down (ping failed) at $(date)"
			echo "Please check all nodes status"
			exit 1
 	        else
   			echo "Host : $myHost is alive"

  		fi
	done

	firewall-cmd --add-port=9696/tcp --permanent
	firewall-cmd --add-port=8774/tcp --permanent
	firewall-cmd --add-port=9292/tcp --permanent
	firewall-cmd --add-port=5000/tcp --permanent
	firewall-cmd --add-port=35357/tcp --permanent
	firewall-cmd --add-port=11211/tcp --permanent
	firewall-cmd --reload

	
	neutron_option="init_provider.sh"

	if [ "$2" == "selfservice" ]; then
		echo "Installing neutron with selfservice feature"
		neutron_option="init_selfservice.sh"
	else
		echo "Installing neutron with provider feaure"
		neutron_option="init_provider.sh"	 

	fi
#	echo "$neutron_option"
#	read

	#check installed packages
        
	if yum -q list installed centos-release-openstack-mitaka &>/dev/null; then
        	echo "Openstack Packages already installed pass eviroment setup"
	else
        	echo "Openstack packages is not installed. Start installing "
		echo "Setting up controller environment"
		$DIR/environment_setup/controller_setup.sh &> "controller_setup.log" &
		spinner $! "openstack packages on controller node"
  		
		echo "Finished"
		echo "Setting up compute environment"
	#scp enviroment file to compute1
	     		
		ssh_setup $compute1 &>>/dev/null
	        scp $DIR/ssh_key_auth.sh $DIR/environment_setup/compute1_setup.sh $DIR/environment_setup/network_setup.sh root@"$compute1":~
		ssh root@$compute1 '~/compute1_setup.sh' &>> "$compute1""_setup.log" &
		spinner $! "openstack packages on compute1 node"
		echo ""
		echo "Finished environment setup"
		 
	fi

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
		   $DIR/networking_service/$neutron_option &> "neutron_install.log" &
       		   spinner $! "Neutron Service"
		   echo " "
		   echo "Depolyment Finished"
		;;
		2)
 	           echo "###        Deploy Option2      ###"
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
		   $DIR/networking_service/$neutron_option &> "neutron_install.log" &
       		   spinner $! "Neutron Service"
		   #echo "install horizon"
		   spinner $! "Horizon Service"
		   $DIR/horizon_service/init.sh &> "horizon_install.log"
		   echo ""
		;;
		3)
		   echo "###       Deploy Option3       ###"
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
		   $DIR/networking_service/$neutron_option &> "neutron_install.log" &
       		   spinner $! "Neutron Service"
		   echo ""
		   #echo "install horizon"
		   $DIR/horizon_service/init.sh &> "horizon_install.log"
		   spinner $! "Horizon Service"
		   echo ""
		   #echo "install swift"
		   $DIR/swift_service/init.sh &> "swift_install.log"
		   spinner $! "Swift Service"
		   echo ""
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
