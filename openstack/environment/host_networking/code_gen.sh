#!/bin/bash

#. $HOME/work/openstack/config/openstack_exported.var

function sub(){

local script_name=
local func_name=sub

for arg in $@
do 
	case arg in
	--script_name=*)
		script_name=${arg#*=}
		func_name=${script_name%.*}	
		shift
	;;
	--*)
	shift
	;;
	esac
done

cat << BEGIN 
$func_name(){
BEGIN

	for arg in $@
	do
	cat << CODE
local arg_$arg=
#arg_$arg=
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
	shift
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
	#return 1
fi
CODE
	done

#code>handling --help
cat << BEGIN
	for o in \$@
	do
		case \$o in
		--help)
		cat <<-HELP
		#Function Name: $func_name
		##Title:
		##Description:
		##Requirement:
BEGIN
		for arg in $@
		do
cat << CODE
		--$arg=[value of $arg]
		shift
CODE
		done
cat << BEGIN2
		##System Impact:
		HELP
		return 0
		;;
		esac
	done
BEGIN2
#code<handling --help

cat << END
	return 0
}

sub \$@
END

}

sub $@ 
#todo: consider using read -r -d instead of cat for here document

