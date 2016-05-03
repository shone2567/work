. share_file_system_for_controller/share_file_system_for_controller.sh

#./ssh-keygen
scp -r share_file_system_for_cinder root@block1:/root

ssh -t root@block1 ". share_file_system_for_cinder/share_file_system_for_cinder.sh"
