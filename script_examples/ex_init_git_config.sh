#!/bin/bash

#   
# Script/Function Name:
#
# Version:
#
# Author:
# 
# Description:
# 
# Effects:
# 
# Parameters:
#  Inputs:
#
#  Ouputs:
#   Standard Output:
# 

exit 0
#you will not execute below commands... after exit...
#check if git is available:

git --version &> /dev/null
is_git_available=$?

if [ ! $is_git_available -eq 0 ]; then #if git is not installed...

	#install git here
	echo "git is not installed yet. now installing..."
	sudo yum install git-all
	wait
	git config --global user.name "$(whoami)"
	git config --global user.email "$(whoami)@$(hostname)" 
	git config --global core.editor vi
	git config --global merge.tool vimdiff
	git config --list

fi

