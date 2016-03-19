#!/bin/bash

#need to be executed by root account
if [ $(whoami) != "root" ]; then
	echo "error: need to be a root account"
	exit 1
fi

#if arg#1 for  username is missing or not set
if [ -z "${1+x}" ]; then
	echo "error: usage $0 <username for adding to sudoer list>"
	exit 1
fi

username=$1
usermod -aG wheel $username



