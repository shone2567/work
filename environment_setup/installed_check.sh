#!/bin/bash

if yum -q list installed $1 &>/dev/null; then
	echo "installed"
else
	echo "not installed"
fi


 
