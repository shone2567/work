yum install -y lvm2

systemctl enable lvm2-lvmetad.service
systemctl start lvm2-lvmetad.service

pvcreate /dev/sdb
vgcreate cinder-volumes /dev/sdb


yum install -y openstack-cinder targetcli

cp -f cinder.conf /etc/cinder/

systemctl enable openstack-cinder-volume.service target.service
systemctl start openstack-cinder-volume.service target.service
