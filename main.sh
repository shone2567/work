#!/bin/bash


main(){
#	echo "install keystone"
#	/root/work/identity_service/init.sh
#	echo "install glance"
#	/root/work/glance_service/init.sh
	echo "install compute"
	/root/work/compute_service/init.sh
	echo "install neutron"
	/root/work/networking_service/init.sh
	echo "install horizon"
	/root/work/horizon_service/init.sh
	echo "install swift"
	/root/work/swift_service/init.sh
}

main

exit 0
