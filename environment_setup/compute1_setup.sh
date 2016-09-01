#!/bin/bash

./network_setup.sh 203.0.113.6
hostnamectl set-hostname compute1
yum install chrony -y
sed -i 's/^server.*//g' /etc/chrony.conf
echo "server controller iburst" >> /etc/chrony.conf
systemctl enable chronyd.service
systemctl start chronyd.service
timedatectl set-timezone America/Los_Angeles


#yum install yum-plugin-priorities -y
#cd /etc/yum.repos.d/
#curl -O http://trunk.rdoproject.org/centos7/delorean-deps.repo
#curl -O http://trunk.rdoproject.org/centos7/current-passed-ci/delorean.repo

yum install centos-release-openstack-mitaka -y
yum upgrade -y
yum install python-openstackclient -y
yum install openstack-selinux -y  
