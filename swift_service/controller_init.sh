#!/bin/bash

set -x

. admin-openrc

./sub_swiftuser_create.sh

openstack role add --project service --user swift admin

openstack service create --name swift \
--description "OpenStack Object Storage" object-store

openstack endpoint create --region RegionOne \
object-store public http://controller:8080/v1/AUTH_%\(tenant_id\)s

openstack endpoint create --region RegionOne \
object-store internal http://controller:8080/v1/AUTH_%\(tenant_id\)s

openstack endpoint create --region RegionOne \
object-store admin http://controller:8080/v1

yum -y install openstack-swift-proxy python-swiftclient \
python-keystoneclient python-keystonemiddleware memcached

curl -o /etc/swift/proxy-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/proxy-server.conf-sample?h=stable/mitaka

openstack-config --set /etc/swift/proxy-server.conf DEFAULT \
bind_port 8080
openstack-config --set /etc/swift/proxy-server.conf DEFAULT \
user swift
openstack-config --set /etc/swift/proxy-server.conf DEFAULT \
swift_dir /etc/swift

sed -i 's/^pipeline =.*/pipeline = catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk ratelimit authtoken keystoneauth container-quotas account-quotas slo dlo versioned_writes proxy-logging proxy-server/' /etc/swift/proxy-server.conf


openstack-config --set /etc/swift/proxy-server.conf app:proxy-server \
use egg:swift#proxy
openstack-config --set /etc/swift/proxy-server.conf app:proxy-server \
account_autocreate True
openstack-config --set /etc/swift/proxy-server.conf filter:keystoneauth \
use egg:swift#keystoneauth
openstack-config --set /etc/swift/proxy-server.conf filter:keystoneauth \
operator_roles admin,user
openstack-config --set /etc/swift/proxy-server.conf filter:authtoken \
paste.filter_factory keystonemiddleware.auth_token:filter_factory

openstack-config --set /etc/swift/proxy-server.conf filter:authtoken \
auth_uri http://controller:5000

openstack-config --set /etc/swift/proxy-server.conf filter:authtoken \
auth_url http://controller:35357

openstack-config --set /etc/swift/proxy-server.conf filter:authtoken \
memcached_servers controller:11211

openstack-config --set /etc/swift/proxy-server.conff filter:authtoken \
auth_type password

openstack-config --set /etc/swift/proxy-server.conf filter:authtoken \
project_domain_name default

openstack-config --set /etc/swift/proxy-server.conf filter:authtoken \
user_domain_name default

openstack-config --set /etc/swift/proxy-server.conf filter:authtoken \
project_name service

openstack-config --set /etc/swift/proxy-server.conf filter:authtoken \
username swift

openstack-config --set /etc/swift/proxy-server.conf filter:authtoken \
password Super123

openstack-config --set /etc/swift/proxy-server.conf filter:authtoken \
delay_auth_decision True


openstack-config --set /etc/swift/proxy-server.conf filter:cache \
use egg:swift#memcache
openstack-config --set /etc/swift/proxy-server.conf filter:cache \
memcache_servers controller:11211

read 

./sub_storagenodes_configure.sh  #installing storage nodes

while [ ! -f ~/object1_finished ]   #wait storage nodes finished
do
   sleep 10
done
########################################################## run command on the controller
cd /etc/swift

swift-ring-builder account.builder create 10 3 1	
swift-ring-builder container.builder create 10 3 1
swift-ring-builder object.builder create 10 3 1


IFS=$'\n' read -d '' -r -a nodes < object_storage_nodes

local count=1 

for node_ip in ${nodes[*]}
do
	swift-ring-builder account.builder add --region 1 --zone $count --ip $node_ip --port 6002 --device sdb --weight 100
	swift-ring-builder account.builder add --region 1 --zone $count --ip $node_ip --port 6002 --device sdc --weight 100

	swift-ring-builder container.builder add --region 1 --zone $count --ip $node_ip --port 6001 --device sdb --weight 100
	swift-ring-builder container.builder add --region 1 --zone $count --ip $node_ip --port 6001 --device sdc --weight 100

	swift-ring-builder object.builder add --region 1 --zone $count --ip $node_ip --port 6000 --device sdb --weight 100
	swift-ring-builder object.builder add --region 1 --zone $count --ip $node_ip --port 6000 --device sdc --weight 100

	count=$(($count+1))
done

#scp {account.ring.gz,container.ring.gz,object.ring.gz} root@object1:/etc/swift
#scp {account.ring.gz,container.ring.gz,object.ring.gz} root@object2:/etc/swift
swift-ring-builder account.builder
swift-ring-builder account.builder rebalance

swift-ring-builder container.builder
swift-ring-builder container.builder rebalance

swift-ring-builder object.builder
swift-ring-builder object.builder rebalance

scp {account.ring.gz,container.ring.gz,object.ring.gz} root@object1:/etc/swift
scp {account.ring.gz,container.ring.gz,object.ring.gz} root@object2:/etc/swift

curl -o /etc/swift/swift.conf \
  https://git.openstack.org/cgit/openstack/swift/plain/etc/swift.conf-sample?h=stable/mitaka

openstack-config --set /etc/swift/swift.conf swift-hash \
swift_hash_path_suffix Super123
openstack-config --set /etc/swift/swift.conf swift-hash \
swift_hash_path_prefix Super123
openstack-config --set /etc/swift/swift.conf storage-policy:0 \
name Policy-0
openstack-config --set /etc/swift/swift.conf storage-policy:0 \
default yes

scp swift.conf root@object1:/etc/swift
scp swift.conf root@object2:/etc/swift

chown -R root:swift /etc/swift

systemctl enable openstack-swift-proxy.service memcached.service
systemctl start openstack-swift-proxy.service memcached.service








