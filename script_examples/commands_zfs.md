zpool create <pool> <raid_type> <disk...>
#zpool creation with Log (Write) 
zpool create <pool> mirror <disk...> mirror <disk...> log mirror <disk...>
#zpool creation with Cache (Read)
zpool create <pool> mirror <disk...> mirror <disk...> cache <disk>
zpool iostat -v pool 5 #checking read write status...
zpool list

zpool status <pool>

#adding another top-level vdev to pool
zpool add <pool> raidz2 <disk...>

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


