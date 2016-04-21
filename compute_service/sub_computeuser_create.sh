#!/usr/bin/expect

set timeout 40

spawn openstack user create --domain default --password-prompt nova
expect "User Password*" { send "Super123\r" }
expect "*Password*:" { send "Super123\r" }
interact

exit 0
