#!/bin/bash

#Only the final condition determines when the loop terminates.

var1=unset
previous=$var1

while echo "previous-variable" = "$previous"
      echo
      previous=$var1
      [ "$var1" != end ]
do
echo "Input variable #1 (end to exit)"
	read var1
	echo "variable #1 = $var1"
done

exit 0 

