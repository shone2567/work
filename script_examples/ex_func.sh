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
#  Ouputs (return value):
#

func(){
   local arg1="undefined"
   arg1=$1
   
   echo "this output will rediret to /dev/null" &> /dev/null
   echo "this function func() is called by $arg1"

   
   #return code = successful
   return 0

}
