#!/bin/bash

test_dir=$HOME/temp/test

if [ ! -d $test_dir ]; then
	mkdir -p $test_dir 
fi
for (( i=0; i<64; i++)){
	sudo dd if=/dev/zero of=$test_dir/$i.testfile bs=1k count=1
	sudo losetup $(losetup -f) $test_dir/$i.testfile
}


