su

yum install openstack-dashboard

#Edit the /etc/openstack-dashboard/local_settings file

systemctl enable httpd.service memcached.service
systemctl restart httpd.service memcached.service
