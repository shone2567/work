#!/usr/bin/expect
spawn openstack user create --domain default --password-prompt demo
expect "User Password*" { send "Super123\r" }
expect "*Password*:" { send "Super123\r" }
interact
