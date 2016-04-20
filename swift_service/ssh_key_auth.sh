#!/usr/bin/expect -f

spawn ssh-copy-id $argv
expect "(yes/no)"
send "yes\n"
expect "password:"
send "Super123\n"
expect eof
