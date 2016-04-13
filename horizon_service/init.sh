#!/bin/bash

set -x

yum install -y openstack-dashboard
/bin/cp -rf local_settings /etc/openstack-dashboard/local_settings
systemctl restart httpd.service memcached.service

exit 0


