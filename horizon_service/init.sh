#!/bin/bash
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
cd /root/work/horizon_service

#set -x

echo "installing horizon package on controller"
yum install -y openstack-dashboard &> /dev/null
/bin/cp -rf local_settings /etc/openstack-dashboard/local_settings
systemctl restart httpd.service memcached.service

exit 0


