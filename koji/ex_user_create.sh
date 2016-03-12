#!/bin/bash

username=$1

sudo useradd $username
sudo passwd $username
sudo gpasswd -a $username wheel
