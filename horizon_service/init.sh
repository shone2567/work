#!/bin/bash

set -x

echo "installing horizon package on controller"
yum install -y openstack-dashboard &>/dev/null
/bin/cp -rf local_settings /etc/openstack-dashboard/local_settings
systemctl restart httpd.service memcached.service

exit 0


