#!/usr/bin/expect

spawn openstack user create --domain default --password-prompt admin
expect "User Password*" { send "Super123\r" }
expect "*Password*:" { send "Super123\r" }
interact

