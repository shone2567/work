#!/bin/bash

set -x 

firewall-cmd --add-port=6000-6003/tcp --permanent
firewall-cmd --reload

yum -y install xfsprogs rsync expect

mkfs.xfs /dev/sdb
mkfs.xfs /dev/sdc

mkdir -p /srv/node/sdb
mkdir -p /srv/node/sdc

echo -e "/dev/sdb /srv/node/sdb xfs noatime,nodiratime,nobarrier,logbufs=8 0 2\n/dev/sdc /srv/node/sdc xfs noatime,nodiratime,nobarrier,logbufs=8 0 2" >>  /etc/fstab

mount /srv/node/sdb
mount /srv/node/sdc

ipaddr="$(ip a show enp0s3 2>/dev/null|awk '$1 ~ /^inet$/ {print $2}'|sed 's/\/.*//')"

cat <<EOF >/etc/rsyncd.conf
uid = swift
gid = swift
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid
address = $ipaddr

[account]
max connections = 2
path = /srv/node/
read only = False
lock file = /var/lock/account.lock

[container]
max connections = 2
path = /srv/node/
read only = False
lock file = /var/lock/container.lock

[object]
max connections = 2
path = /srv/node/
read only = False
lock file = /var/lock/object.lock
EOF

systemctl enable rsyncd.service
systemctl start rsyncd.service

yum -y install openstack-swift-account openstack-swift-container openstack-swift-object openstack-utils 

curl -o /etc/swift/account-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/account-server.conf-sample?h=stable/mitaka
curl -o /etc/swift/container-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/container-server.conf-sample?h=stable/mitaka
curl -o /etc/swift/object-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/object-server.conf-sample?h=stable/mitaka

openstack-config --set /etc/swift/account-server.conf DEFAULT \
bind_ip $ipaddr
openstack-config --set /etc/swift/account-server.conf DEFAULT \
bind_port 6002
openstack-config --set /etc/swift/account-server.conf DEFAULT \
user swift
openstack-config --set /etc/swift/account-server.conf DEFAULT \
swift_dir /etc/swift
openstack-config --set /etc/swift/account-server.conf DEFAULT \
devices /srv/node
openstack-config --set /etc/swift/account-server.conf DEFAULT \
mount_check True

sed -i 's/^pipeline =.*/pipeline = healthcheck recon account-server/' /etc/swift/account-server.conf

openstack-config --set /etc/swift/account-server.conf filter:recon \
use egg:swift#recon
openstack-config --set /etc/swift/account-server.conf filter:recon \
recon_cache_path /var/cache/swift


openstack-config --set /etc/swift/container-server.conf DEFAULT \
bind_ip $ipaddr
openstack-config --set /etc/swift/container-server.conf DEFAULT \
bind_port 6001
openstack-config --set /etc/swift/container-server.conf DEFAULT \
user swift
openstack-config --set /etc/swift/container-server.conf DEFAULT \
swift_dir /etc/swift
openstack-config --set /etc/swift/container-server.conf DEFAULT \
devices /srv/node
openstack-config --set /etc/swift/container-server.conf DEFAULT \
mount_check True

sed -i 's/^pipeline =.*/pipeline = healthcheck recon account-server/' /etc/swift/container-server.conf

openstack-config --set /etc/swift/container-server.conf filter:recon \
use egg:swift#recon
openstack-config --set /etc/swift/container-server.conf filter:recon \
recon_cache_path /var/cache/swift

openstack-config --set /etc/swift/object-server.conf DEFAULT \
bind_ip $ipaddr
openstack-config --set /etc/swift/object-server.conf DEFAULT \
bind_port 6000
openstack-config --set /etc/swift/object-server.conf DEFAULT \
user swift
openstack-config --set /etc/swift/object-server.conf DEFAULT \
swift_dir /etc/swift
openstack-config --set /etc/swift/object-server.conf DEFAULT \
devices /srv/node
openstack-config --set /etc/swift/object-server.conf DEFAULT \
mount_check True

sed -i 's/^pipeline =.*/pipeline = healthcheck recon account-server/' /etc/swift/object-server.conf

openstack-config --set /etc/swift/object-server.conf filter:recon \
use egg:swift#recon
openstack-config --set /etc/swift/object-server.conf filter:recon \
recon_cache_path /var/cache/swift

chown -R swift:swift /srv/node
mkdir -p /var/cache/swift
chown -R root:swift /var/cache/swift
chmod -R 775 /var/cache/swift

filename="`hostname`_finished"
touch ~/"$filename"

mkdir ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -f id_rsa -t rsa -N ''
cp id_rsa id_rsa.pub "/root/.ssh/"
rm -f id_rsa id_rsa.pub

/root/ssh_key_auth.sh controller
scp ~/"$filename" root@controller:~/

while [ ! -f /etc/swift/controller_finished ]   #wait storage nodes finished
do
   echo "waiting for controller finishing installation"
   sleep 5
done

chown -R root:swift /etc/swift

systemctl enable openstack-swift-account.service openstack-swift-account-auditor.service \
openstack-swift-account-reaper.service openstack-swift-account-replicator.service

systemctl start openstack-swift-account.service openstack-swift-account-auditor.service \
openstack-swift-account-reaper.service openstack-swift-account-replicator.service

systemctl enable openstack-swift-container.service \
openstack-swift-container-auditor.service openstack-swift-container-replicator.service \
openstack-swift-container-updater.service

systemctl start openstack-swift-container.service \
openstack-swift-container-auditor.service openstack-swift-container-replicator.service \
openstack-swift-container-updater.service

systemctl enable openstack-swift-object.service openstack-swift-object-auditor.service \
openstack-swift-object-replicator.service openstack-swift-object-updater.service

systemctl start openstack-swift-object.service openstack-swift-object-auditor.service \
openstack-swift-object-replicator.service openstack-swift-object-updater.service


exit 0
