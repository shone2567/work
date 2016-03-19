#!/bin/bash

sub_zpool_destroy(){

	local zfs_rcache_postfix="*\.vcache"
	local zfs_vdisk_dir="$HOME/temp/zfs/vdisks"
	local zfs_vlog_dir="$HOME/temp/zfs/vlogs"
	local zfs_vcache_dir="$HOME/temp/zfs/vcaches"
	local zpool="pool1"
	sudo zpool destroy $zpool
	sudo zpool list
	sudo zpool status

	#remove all vdisks and vdevices
	rm -r $zfs_vdisk_dir
	rm -r $zfs_vlog_dir
	rm -r $zfs_vcache_dir
		
	#clean up the loop device
	sudo losetup | grep -E "$zfs_rcache_postfix" | cut -d " " -f 1 | xargs sudo losetup -d

}
sub_zpool_destroy

