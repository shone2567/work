#!/bin/bash


cd /root/work/environment_setup
./network_setup.sh 203.0.113.5
hostnamectl set-hostname controller
#installing NTP

yum install -y chrony
echo "allow 10.0.0.0/24" >> /etc/chrony.conf
systemctl enable chronyd.service
systemctl start chronyd.service
timedatectl set-timezone America/Los_Angeles
firewall-cmd --add-service=ntp --permanent
firewall-cmd --reload

#installing Openstack packages

yum install yum-plugin-priorities -y
cd /etc/yum.repos.d/
curl -O http://trunk.rdoproject.org/centos7/delorean-deps.repo
curl -O http://trunk.rdoproject.org/centos7/current-passed-ci/delorean.repo
yum install centos-release-openstack-mitaka -y
yum upgrade -y
yum install python-openstackclient -y
yum install openstack-selinux -y

# Install and Configure Database
yum install mariadb mariadb-server python2-PyMySQL -y
cp /etc/my.cnf.d/mariadb-server.cnf /etc/my.cnf.d/openstack.cnf
sed -r -i "/(\[mysqld\])/abind-address = 10.0.0.11\ndefault-storage-engine = innodb\ninnodb_file_per_table\ncollation-server = utf8_general_ci\ncharacter-set-server = utf8" /etc/my.cnf.d/openstack.cnf

systemctl enable mariadb.service
systemctl start mariadb.service

yum -y install expect

MYSQL_ROOT_PASSWORD=Super123

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"\r\"
expect \"Change the root password?\"
send \"y\r\"
expect \"New password?\"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Re-enter new password?\"
send \"$MYSQL_ROOT_PASSWORD\r\"

expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL ***************************"


# Install rabbitmq
yum install rabbitmq-server -y
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
sleep 5
rabbitmqctl add_user openstack Super123
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# Install memcached 
yum install memcached python-memcached -y
systemctl enable memcached.service
systemctl start memcached.service


exit 0
