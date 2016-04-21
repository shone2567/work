#environment

#identity service

#image service
. /image_service_mitaka/image_service_deploy.sh

#compute service
#controller

. /compute_service_mitaka/



#compute
scp /compute_service_mitaka/ root@compute1:/root


