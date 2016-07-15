#!/bin/bash

set -x
/bin/cp hostname /etc/hostname
/bin/cp hosts    /etc/hosts
/bin/cp interfaces /etc/network/interfaces
/bin/cp -r network/interfaces.d/ /etc/network
/bin/cp resolv.conf /etc/resolv.conf
/bin/cp -r quagga/ /etc/quagga
/bin/cp -r ssh/ /etc/ssh/

exit 0
~

