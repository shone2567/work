#zpool creation
zpool create <pool> <raid_type> <disk...>
zpool create -m <mount_point> <pool> <raid_type> <disk...>
	example: zpool create -m /export/zfs pool1 raidz2 <disk...>

#zpool creation with Log (Write) 
zpool create <pool> mirror <disk...> mirror <disk...> log mirror <disk...>
#zpool creation with Cache (Read)
zpool create <pool> mirror <disk...> mirror <disk...> cache <disk>
zpool iostat -v pool 5 #checking read write status...
zpool list

zpool status <pool>

#adding another top-level vdev to pool
zpool add <pool> raidz2 <disk...>
zpool add <pool> mirror <disk1> <disk2> <disk3>
#adding read cache
zpool add <pool> cache <disks>

#removing read cache
zpool remove <pool> <cache disks...>
#removing vdev
zpool remove <pool> <vdev>
	example: zpool remove pool1 mirror-1
	example: zpool remove pool1 <log_single_disk>

zfs create <pool>/<zvol>

zfs set <property>=<property value> <pool>/<zvol>
zfs set mountpoint=<mount path> <pool>/<zvol>
zfs set sharenfs=on <pool>/<zvol>
zfs set compression=on <pool>/<zvol>
zfs get compression <pool>/<zvol>
#alternative:
zfs create -o mountpoint=<mount path> -o sharenfs=on -o compression=on <pool>/<zvol>

zfs list

zpool destroy <pool>


