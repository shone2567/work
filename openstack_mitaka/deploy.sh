#environment

#identity service

#image service
. /image_service_mitaka/image_service_deploy.sh

#compute service
#controller

. /compute_service_mitaka/compute_service_for_controller/compute_service_controller_node_deploy.sh

#compute
scp -r /compute_service_mitaka/compute_service_for_compute root@compute1:/root
ssh root@compute1

. /compute_service_for_compute/compute_service_compute_node_deploy.sh



