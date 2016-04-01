#!/bin/bash


input=/etc/passwd


test ()
{
        while read line
	do 
		echo "$line" | grep root | awk -F":" '{ print $5}'
	done
	echo "in function"
	} <$input


test 
