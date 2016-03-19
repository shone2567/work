#!/bin/bash


#check if git is available. if not then it wil lnstall git

git --version &> /dev/null
is_git_available=$?

if [ ! $is_git_available -eq 0 ]; then #if git is not installed...

        #install git here
        echo "git is not installed yet. now installing..."
        sudo yum install git-all
	wait
fi
        git config --global user.name "$(whoami)"
        git config --global user.email "$(whoami)@$(hostname)"
        git config --global core.editor vi
        git config --global merge.tool vimdiff
        git config --list


