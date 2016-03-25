#!/bin/bash

. $HOME/work/openstack/config/openstack_exported.var
function sub_opt_handler(){
cat << BEGIN
sub(){

for o in \$@
do
	case \$o in
	--help)
	cat <<-HELP
	#Script: $0
	##Title:
	##Description:
	##Requirement:
BEGIN
	for arg in $@
	do
	cat << CODE
	--$arg=<value of $arg>
CODE
	done
cat << BEGIN2
	##System Impact:
	HELP
	exit 0
	;;
	esac
done

BEGIN2

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
	>&2 echo "info: arg_$arg=\$arg_$arg"
fi
CODE
	done
cat << END
}

sub \$@
END

}

sub_opt_handler $@

