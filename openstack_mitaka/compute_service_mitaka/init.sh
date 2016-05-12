. compute_service_for_controller/compute_service_controller_node_deploy.sh

scp -rf computer_service_for_compute root@compute1:/root
ssh -t root@compute1 ". compute_service_for_compute/compute_service_compute_node_deploy.sh"
