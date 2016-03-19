#!/bin/bash


main(){

	if [ $# -ne 1 ]; then
		echo "Usage : $0 Deploy Option"
		echo "Please check $0 --help"
		exit
	fi
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
		1) echo "         Deploy Option1"
		   echo "##################################################"
		   echo "install keystone"
		   /root/work/identity_service/init.sh
       		   echo "install glance"
         	   /root/work/glance_service/init.sh
                   echo "install compute"
                   /root/work/compute_service/init.sh
       		   echo "install neutron"
		   /root/work/networking_service/init.sh
		;;
		2)
 	           echo "         Deploy Option2"
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
		   echo "         Deploy Option3"
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

main "$@"



exit 0
