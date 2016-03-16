ip_controller=$1

sudo yum install chrony

#copy file to the controller node
sshpass -p '123456' scp -f chrony.conf root@$ip_controller:/etc/

#enable and start the service
systemctl enable chronyd.service
systemctl start chronyd.service
