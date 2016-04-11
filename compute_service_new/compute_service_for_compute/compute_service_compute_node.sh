#su

yum -y install openstack-nova-compute sysfsutils

acceleration=`egrep -c '(vmx|svm)' /proc/cpuinfo`
echo $acceleration

if [ $acceleration -eq 0 ];
then
	cp -f nova_not_support_hw_acceleration/nova.conf /etc/nova;
else
	cp -f nova_support_hw_acceleration/nova.conf /etc/nova;
fi

#Edit the [libvirt] section in the /etc/nova/nova.conf file

systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service openstack-nova-compute.service
