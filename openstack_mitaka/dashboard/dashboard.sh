#su

yum install -y openstack-dashboard

#Edit the /etc/openstack-dashboard/local_settings file
cp -f local_settings /etc/openstack-dashboard/

#systemctl enable httpd.service memcached.service
systemctl restart httpd.service memcached.service

firewall-cmd --zone=public --add-service=http --permanent
systemctl restart firewalld.service
