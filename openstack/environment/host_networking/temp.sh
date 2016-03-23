#local arg_ddd=
arg_ddd=
#local arg_eee=
arg_eee=
#local arg_fff=
arg_fff=
for o in $@
do
	case $o in
	--help)
	#echo "help msg here"
	;;
	--ddd=*)
	arg_ddd=${o#*=}
	;;
	--eee=*)
	arg_eee=${o#*=}
	;;
	--fff=*)
	arg_fff=${o#*=}
	;;
	*)
	;;
	esac
done
if [ ${#arg_ddd} -eq 0  ]; then
	>&2 echo "arg_ddd: $arg_ddd"
fi
if [ ${#arg_eee} -eq 0  ]; then
	>&2 echo "arg_eee: $arg_eee"
fi
if [ ${#arg_fff} -eq 0  ]; then
	>&2 echo "arg_fff: $arg_fff"
fi
