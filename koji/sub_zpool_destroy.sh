#!/bin/bash

sub_zpool_destroy(){

	local zpool="pool1"
	sudo zpool destroy $zpool
	sudo zpool list
	sudo zpool status

}
sub_zpool_destroy

