echo 

echo "Testing \"0\""

if [ 0 ]
then
	echo "0 is true"
else
	echo "0 is false"
fi

echo

echo "Testing \"1\""
if [ 1 ]
then
	echo "0 is true"
else
	echo "0 is false"
fi

echo

echo "Testing \"-1\""
if [ -1 ]
then
	echo "-1 is true"
else
	echo "-1 is false"
fi

echo

echo "Testing \"NULL\""
if [  ]
then
	echo " is true"
else
	echo " is false"
fi

echo

echo "Testing \"xyz\""
if [ xyz ]
then
	echo "random string is true"
else
	echo "random string is false"
fi

echo

echo "Testing \"\$xyz\""
if [ $xyz ]
then
	echo "uninitialized variable is true"
else
	echo "uninitialized variable is false"
fi

echo

echo "Testing \"-n \$xyz\""
if [ -n $xyz ]
then
	echo "Uninitialized variable is true"
else
	echo "Uninitialized variable is false"
fi

xyz= 

echo "Testing \"-n \&xyz\""

if [ -n "$xyz"]
then 
	echo "Null variable is true"
else
	echo "Null variable is false"
fi

echo


#false

echo "Testing \"false\""

if [ "false" ]
then 
	echo "\"false\ is true."
fi

echo


echo "Testing \"\$false\""
if [ "$false" ]
then 
	echo "\"\$false\" is true."
else
	echo "\"\$false\" is false."
fi


echo 


exit 0


# Using the [[.....]] test construct, rather than [..] can prevent many logic errors in scripts. For example, the &&,||,<,and>operators work within a [[]] test, despite giving an error within a [] construct

