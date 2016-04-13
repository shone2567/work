#!/usr/bin/expect -f
#cd ~/.ssh
#ssh-keygen -f id_rsa -t rsa -N ''

spawn ssh-copy-id $argv
expect "(yes/no)"
send "yes\n"
expect "password:"
send "Super123\n"
expect eof
