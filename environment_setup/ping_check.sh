#!/bin/bash

HOSTS="10.0.0.31 10.0.0.11"

# email report when
for myHost in $HOSTS
do
  count=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
  if [ $count -eq 0 ]; then
    # 100% failed
    echo "Host : $myHost is down (ping failed) at $(date)" 
  else
    echo "Host : $myHost is alive"	

  fi
done
