
#execute
. cinder/controller/block_storage_service.sh

./ssh-keygen
scp -r cinder_storage root@block1

#change to block
ssh root@block1
./block_storage_service_deploy.sh


