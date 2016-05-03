yum install -y openstack-manila-share python2-PyMySQL

openstack-config --set /etc/manila/manila.conf database connection mysql://manila:Super123@controller/manila
openstack-config --set /etc/manila/manila.conf DEFAULT rpc_backend rabbit
openstack-config --set /etc/manila/manila.conf oslo_messaging_rabbit rabbit_host controller
openstack-config --set /etc/manila/manila.conf oslo_messaging_rabbit rabbit_userid openstack
openstack-config --set /etc/manila/manila.conf oslo_messaging_rabbit rabbit_password Super123
openstack-config --set /etc/manila/manila.conf DEFAULT default_share_type default_share_type
openstack-config --set /etc/manila/manila.conf DEFAULT rootwrap_config /etc/manila/rootwrap.conf
openstack-config --set /etc/manila/manila.conf DEFAULT auth_strategy keystone
openstack-config --set /etc/manila/manila.conf keystone_authtoken memcached_servers controller:11211
openstack-config --set /etc/manila/manila.conf keystone_authtoken auth_uri http://controller:5000
openstack-config --set /etc/manila/manila.conf keystone_authtoken auth_url http://controller:35357
openstack-config --set /etc/manila/manila.conf keystone_authtoken auth_type password
openstack-config --set /etc/manila/manila.conf keystone_authtoken project_domain_name default
openstack-config --set /etc/manila/manila.conf keystone_authtoken user_domain_name default
openstack-config --set /etc/manila/manila.conf keystone_authtoken project_name service
openstack-config --set /etc/manila/manila.conf keystone_authtoken username manila
openstack-config --set /etc/manila/manila.conf keystone_authtoken password Super123
openstack-config --set /etc/manila/manila.conf DEFAULT my_ip 10.0.0.41
openstack-config --set /etc/manila/manila.conf oslo_concurrency lock_path /var/lib/manila/tmp

yum install -y lvm2 nfs-utils nfs4-acl-tools portmap
systemctl enable lvm2-lvmetad.service
systemctl start lvm2-lvmetad.service

pvcreate /dev/sdc
vgcreate manila-volumes /dev/sdc

#change lvm file
#cp -f lvm.conf /etc/lvm/

#sed -i "s%filter = [ "a/sdb/", "r/.*/"]%filter = [ "a/sdb/", "a/sdc/", "r/.*/"]%g" /etc/lvm/lvm.conf
sed -i '/devices {/{n;d}' /etc/lvm/lvm.conf
sed -i 's|.*devices {.*|&\nfilter = [ "a/sdb/", "a/sdc/", "r/.*/"]|' /etc/lvm/lvm.conf


openstack-config --set /etc/manila/manila.conf DEFAULT enabled_share_backends lvm
openstack-config --set /etc/manila/manila.conf DEFAULT enabled_share_protocols NFS,CIFS
openstack-config --set /etc/manila/manila.conf lvm share_backend_name LVM
openstack-config --set /etc/manila/manila.conf lvm share_driver manila.share.drivers.lvm.LVMShareDriver
openstack-config --set /etc/manila/manila.conf lvm driver_handles_share_servers False
openstack-config --set /etc/manila/manila.conf lvm lvm_share_volume_group manila-volumes
openstack-config --set /etc/manila/manila.conf lvm lvm_share_export_ip 10.0.0.41

systemctl enable openstack-manila-share.service
systemctl start openstack-manila-share.service
