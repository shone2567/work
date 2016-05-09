#move to your home directory
#create vim .vimrc file

file=$HOME/.vimrc
if [ ! -f $file ]; then
	touch $file 
	echo "set ts=3" >> $file				#set tab space to 3 chars
	echo "set background=dark" >> $file
fi
