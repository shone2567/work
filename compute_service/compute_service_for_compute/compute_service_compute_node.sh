#su

yum -y install openstack-nova-compute sysfsutils

cp -f nova.conf /etc/nova/nova.conf

egrep -c '(vmx|svm)' /proc/cpuinfo

#Edit the [libvirt] section in the /etc/nova/nova.conf file

systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service openstack-nova-compute.service
