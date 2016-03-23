
#disconnect network interface (=ifdown)
sudo nmcli device disconnect [eno33554984]
#adding network connection/device (this will create ifcfg-mgmt file…)
sudo nmcli connection add type ethernet con-name [mgmt.] ifname [eno33554984] ip4 [10.0.0.11/24] gw4 [10.0.0.1] #this will create ifcfg-mgmt file
#similiar to ifup….
sudo nmcli connection up [mgmt] ifname [eno33554984]
#check network device status
nmcli device status
#changing ip address
nmcli connection modify [mgmt] ipv4.addresses [new ipaddress/bitmast]
#changing onboot=yes
nmcli connection modify [mgmt] connect.autoconnect yes
#check network connection status in detail
nmcli -p connection show [mgmt]
#disconnect network interface (=ifdown) again…
sudo nmcli device disconnect eno33554984
#delete the ifcfg file (if you want…)
sudo nmcli connection delete mgmt.


source:
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/sec-Using_the_NetworkManager_Command_Line_Tool_nmcli.html

#renaming network device (example):
/sbin/ip link set eth1 down
/sbin/ip link set eth1 name eth123
/sbin/ip link set eth123 up

##see also:
http://unix.stackexchange.com/questions/205010/centos-7-rename-network-interface-without-rebooting

