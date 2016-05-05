#execute
. cinder_controller/block_storage_service_deploy.sh

./ssh-keygen
scp -r cinder_storage root@block1:/root

#change to block
ssh -t root@block1 ". cinder_storage/block_storage_service_deploy.sh &> /dev/null"


