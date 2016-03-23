#!/bin/bash

. $HOME/work/openstack/config/openstack_exported.var
function sub_opt_handler(){
	for arg in $@
	do
	cat << CODE
#local arg_$arg=
arg_$arg=
CODE
	done
	cat << CODE
for o in \$@
do
	case \$o in
	--help)
	cat << HELP
#Script: $0
##Title:
##Description:
##System Impact:
HELP
	;;
CODE
	
	for arg in $@
	do
	cat << CODE
	--$arg=*)
	arg_$arg=\${o#*=}
	;;
CODE
	done
	cat << CODE
	*)
	;;
	esac
done
CODE
	for arg in $@
	do
	cat << CODE
if [ \${#arg_$arg} -eq 0  ]; then
	>&2 echo "arg_$arg: \$arg_$arg"
fi
CODE
	done


}

sub_opt_handler $@

