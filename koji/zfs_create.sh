#!/bin/bash

./sub_vdisk_create.sh 6
./sub_wcache_create.sh 3
./sub_rcache_create.sh 3
./sub_zpool_create.sh
./sub_zvol_create.sh



#./sub_zpool_destroy.sh
