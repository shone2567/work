#!/bin/bash
#

echo

var="(]\\{}\$\""

echo $var
echo "$var"

echo

IFS='\'
echo $var
echo "$var"

echo 

ABC=$'\101\102\103\103\010'
echo $ABC


cat <<EOF
\Z
asdfas' rgherherhth''rtewrte'!!!!$	#$Qrh

rgwergwhtrwth

EOF


