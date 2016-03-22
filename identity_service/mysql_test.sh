#!/bin/bash
mysql -u root -pSuper123 << EOF
use keystone;
show tables;
EOF
