#!/bin/bash


main(){

	if [ $# -ne 1 ]; then
		echo "####################################"
		echo "Usage : $0 Deploy Option"
		echo "Please check $0 --help"
		exit
	fi
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
                   #echo "install compute"
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

main "$@"



exit 0
