#!/bin/bash

function code_create_script_template(){

local script_name=$1
local func_name=sub
local CODE=

if [ ${#script_name} -gt 0 ]; then
	func_name=${script_name%%.*}
fi

for o in $@
do
	case $o in
	--help)
	cat <<-HELP
	#Script Name: $0 
	#Function Name: ${0/%%.*}
	##Title:
	##Description:
	##Requirement:
	$0 --script_name=[script_name]
	##System Impact:
	HELP
	shift
	return 0
	;;
	esac
done

read -r -d '' CODE << END
#!/bin/bash

$func_name(){

###FUNC_BODY###

} 

#$func_name \$@

END

echo "$CODE" > $script_name
sudo chmod 755 $script_name
}
code_create_script_template $@
sub(){

for o in $@
do
	case $o in
	*)
	;;
	esac
done
	return 0
}

sub $@
