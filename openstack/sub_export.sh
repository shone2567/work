#!/bin/bash

var_file=sub_var.sh

cat $var_file | sed -e "s/=.*//g" | sed -e "s/^/export /g" >> ${var_file}_export

