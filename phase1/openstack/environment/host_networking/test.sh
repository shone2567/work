#!/bin/bash
#var_exec="no"
sub(){
	local arg_aaa=
	#arg_aaa=
	local arg_bbb=
	#arg_bbb=
	local arg_xxx=
	#arg_xxx=
	for o in $@
	do
		case $o in
		--help)
		cat <<-HELP
		#Function Name: sub
		##Title:
		##Description:
		##Requirement:
		#--exec=[yes|no] #default "no"
		--aaa=[value of aaa]
		--bbb=[value of bbb]
		--xxx=[value of xxx]
		##System Impact:
		HELP
		return 0
		;;
		esac
	done
for o in $@
do
	case $o in
	#--exec=*)
	#var_exec=${o#*=}
	#if [ $var_exec != "yes" ]; then
	#	var_exec="no"			
	#fi
	#shift
	#;;
	--aaa=*)
	arg_aaa=${o#*=}
	shift
	;;
	--bbb=*)
	arg_bbb=${o#*=}
	shift
	;;
	--xxx=*)
	arg_xxx=${o#*=}
	shift
	;;
	*)
	;;
	esac
done
if [ ${#arg_aaa} -eq 0  ]; then
	>&2 echo "info: arg_aaa=$arg_aaa"
	#return 1
fi
if [ ${#arg_bbb} -eq 0  ]; then
	>&2 echo "info: arg_bbb=$arg_bbb"
	#return 1
fi
if [ ${#arg_xxx} -eq 0  ]; then
	>&2 echo "info: arg_xxx=$arg_xxx"
	#return 1
fi
	return 0
}

#if [ "$var_exec" == "yes" ]; then 
	sub $@
#fi
#exit 0
