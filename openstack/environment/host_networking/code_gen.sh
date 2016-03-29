#!/bin/bash

#. $HOME/work/openstack/config/openstack_exported.var
_script=
_func=sub

function sub(){


for arg in $@
do 
	case arg in
	--script_name=*)
		_script=${arg#*=}
		_func=${script_name%.*}	
		shift
	;;
	esac
done

cat << BEGIN 
#!/bin/bash
#var_exec="no"
$_func(){
BEGIN

	for arg in $@
	do
	cat << CODE
	local arg_$arg=
	#arg_$arg=
CODE
	done

#code>handling --help
cat << BEGIN
	for o in \$@
	do
		case \$o in
		--help)
		cat <<-HELP
		#Function Name: $_func
		##Title:
		##Description:
		##Requirement:
		#--exec=[yes|no] #default "no"
BEGIN
		for arg in $@
		do
cat << CODE
		--$arg=[value of $arg]
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


	cat << CODE
for o in \$@
do
	case \$o in
	#--exec=*)
	#var_exec=\${o#*=}
	#if [ \$var_exec != "yes" ]; then
	#	var_exec="no"			
	#fi
	#shift
	#;;
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

cat << END
	return 0
}

#if [ "\$var_exec" == "yes" ]; then 
	$_func \$@
#fi
#exit 0
END

}

sub $@
#todo: consider using read -r -d instead of cat for here document

