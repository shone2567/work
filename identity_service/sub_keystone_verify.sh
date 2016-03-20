#!/usr/bin/expect

spawn openstack --os-auth-url http://controller:35357/v3 \
  --os-project-domain-id default --os-user-domain-id default \
  --os-project-name admin --os-username admin --os-auth-type password \
  token issue
expect "*Password*:" { send "Super123\r" }
interact
exit 0
