#!/usr/bin/expect


set timeout 40
spawn openstack user create --domain default --password-prompt glance
expect "User Password:" { send "Super123\r" }
expect "Repeat User Password:" { send "Super123\r" }
interact

