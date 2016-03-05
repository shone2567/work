#!/bin/bash
# Source: http://zfsonlinux.org/epel.html

sudo yum localinstall --nogpgcheck https://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sudo yum localinstall --nogpgcheck http://archive.zfsonlinux.org/epel/zfs-release.el7.noarch.rpm
sudo yum install kernel-devel zfs 

