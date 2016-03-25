sub(){

for o in $@
do
	case $o in
	--help)
	cat <<-HELP
	#Script: `$0`
	##Title:
	##Description:
	##Requirement:
	--aaa=<value of aaa>
	--bbb=<value of bbb>
	--ccc=<value of ccc>
	##System Impact:
	HELP
	exit 0
	;;
	esac
done

#local arg_aaa=
arg_aaa=
#local arg_bbb=
arg_bbb=
#local arg_ccc=
arg_ccc=
for o in $@
do
	case $o in
	--aaa=*)
	arg_aaa=${o#*=}
	;;
	--bbb=*)
	arg_bbb=${o#*=}
	;;
	--ccc=*)
	arg_ccc=${o#*=}
	;;
	*)
	;;
	esac
done
if [ ${#arg_aaa} -eq 0  ]; then
	>&2 echo "info: arg_aaa=$arg_aaa"
fi
if [ ${#arg_bbb} -eq 0  ]; then
	>&2 echo "info: arg_bbb=$arg_bbb"
fi
if [ ${#arg_ccc} -eq 0  ]; then
	>&2 echo "info: arg_ccc=$arg_ccc"
fi
}

sub $@
