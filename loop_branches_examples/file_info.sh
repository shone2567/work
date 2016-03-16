#!/bin/bash

FILES=" /usr/sbin/accept
/usr/sbin/pwck
/usr/sbin/chroot"

echo 

for file in $FILES
do 
	if [ ! -e "$file" ]
	then
		echo "$file does not exist.";echo
		continue
	fi

	ls -l $file | awk '{ print $8 "  file size: " $5}'
	whatis `basename $file`
	echo
done

exit 0 
