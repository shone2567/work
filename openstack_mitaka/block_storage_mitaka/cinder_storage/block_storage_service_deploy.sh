yum install -y lvm2

systemctl enable lvm2-lvmetad.service
systemctl start lvm2-lvmetad.service


#cp -f block_storage_mitaka/cinder_storage/lvm.conf /etc/lvm/
sed -i 's/.*devices {.*/&\nfilter = [ "a/sdb/", "r/.*/"]/' /etc/lvm/lvm.conf

pvcreate /dev/sdb
vgcreate cinder-volumes /dev/sdb

#lvm file
#scp block_storage_mitaka/cinder_storage/lvm.conf root@block1:/root
#ssh root@block1
#cd /root


yum install -y openstack-cinder targetcli

openstack-config --set /etc/cinder/cinder.conf database connection mysql+pymysql://cinder:Super123@controller/cinder
openstack-config --set /etc/cinder/cinder.conf DEFAULT rpc_backend rabbit
openstack-config --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_host controller
openstack-config --set /etc/cinder/cinder.conf rabbit_userid openstack
openstack-config --set /etc/cinder/cinder.conf rabbit_password Super123
openstack-config --set /etc/cinder/cinder.conf DEFAULT auth_strategy keystone
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken auth_uri http://controller:5000
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken auth_url http://controller:35357
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken memcached_servers controller:11211
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken auth_type password
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken project_domain_name default
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken user_domain_name default
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken project_name service
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken username cinder
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken password Super123
openstack-config --set /etc/cinder/cinder.conf DEFAULT my_ip 10.0.0.41
openstack-config --set /etc/cinder/cinder.conf lvm volume_driver cinder.volume.drivers.lvm.LVMVolumeDriver
openstack-config --set /etc/cinder/cinder.conf lvm volume_group cinder-volumes
openstack-config --set /etc/cinder/cinder.conf lvm iscsi_protocol iscsi
openstack-config --set /etc/cinder/cinder.conf lvm iscsi_helper lioadm
openstack-config --set /etc/cinder/cinder.conf DEFAULT enabled_backends lvm
openstack-config --set /etc/cinder/cinder.conf DEFAULT glance_api_servers http://controller:9292
openstack-config --set /etc/cinder/cinder.conf oslo_concurrency lock_path /var/lib/cinder/tmp


systemctl enable openstack-cinder-volume.service target.service
systemctl start openstack-cinder-volume.service target.service
