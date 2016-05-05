#!/bin/bash

#	memo:
#	this script will take any envionment variable settings and 
#	first generate export and unset files, then execute the 
#	export file.

input_file=openstack.var
output_file_export=
output_file_unset=
output_file_echo=

if [ $# -gt 0 ]; then
	echo "arg#: $#"
	input_file=$1
fi

output_file_export=${input_file%\.var}_exported.var
#output_file_export=${input_file%\.var}_export.sh
#output_file_unset=${input_file%\.var}_unset.sh
#output_file_echo=${input_file%\.var}_echo.sh
#
#echo "#!$BASH" > $output_file_export
cat $input_file | grep -E ".+=.+" > $output_file_export
cat $input_file | grep -E ".+=.+" | sed -e "s/=.*//g" | sed -e "s/^/export /g" >> $output_file_export
#chmod 775 $output_file_export
chmod 664 $output_file_export
#
#echo "#!$BASH" > $output_file_unset
#cat $input_file | grep -E ".+=.+" | sed -e "s/=.*//g" | sed -e "s/^/unset /g" >> $output_file_unset
#chmod 775 $output_file_unset
#
#echo "#!$BASH" > $output_file_echo
#cat $input_file | grep -E ".+=.+" | sed -e "s/=.*//g" | sed -e "s/^/echo $/g" >> $output_file_echo
#chmod 775 $output_file_echo
#
