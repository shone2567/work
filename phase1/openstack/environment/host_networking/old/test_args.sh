a(){
	echo "---processing a---"
	for i in $@
	do
		echo "$i"
	done
	b xxx yyy zzz
	echo "---processing a #3---"
	for i in $@
	do
		echo "$i"
	done
	
}
b(){
	echo "---processing b #2---"
	for i in $@
	do
		echo "$i"
	done
}
a $@
