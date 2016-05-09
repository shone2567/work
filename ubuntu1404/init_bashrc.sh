FILE=$HOME/.myrc

if [ ! -f $FILE ]; then
	echo "#adding personal rc file" >> $HOME/.bashrc
	echo "source $FILE" >> $HOME/.bashrc
	touch $FILE
fi 
