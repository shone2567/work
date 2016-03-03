#!/bin/bash
#IFS=$'
#'
declare -a ARRAY #it is an array variable
FILE="data_sample.txt"
#ARRAY=(aaa
#bbb
#ccc
#)
ARRAY=($(cat $FILE))

echo "${ARRAY[*]}"

#unset IFS

