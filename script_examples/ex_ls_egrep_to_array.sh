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
#


FILTER="*\.sh"

declare -a ARRAY

ARRAY=($(ls | grep -E "$FILTER"))

echo "${ARRAY[*]}"


