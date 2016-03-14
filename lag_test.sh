#main host
ip_host=$1
ip_client=$2
ip_client_second=$3
ip_client_third=$4

send="iperf -s"

gnome-terminal -e "sshpass -p '123456' ssh root@$ip_host -o StrictHostKeyChecking=no $send"


sleep 5


current_time=$(date +"%m-%d-%y-%T")
sshpass -p '123456' ssh root@$ip_client -o StrictHostKeyChecking=no rm -rf /root/Desktop/iperf_log_$ip_client
sshpass -p '123456' ssh root@$ip_client -o StrictHostKeyChecking=no mkdir /root/Desktop/iperf_log_$ip_client
sshpass -p '123456' ssh root@$ip_client_second -o StrictHostKeyChecking=no rm -rf /root/Desktop/iperf_log_$ip_client_second
sshpass -p '123456' ssh root@$ip_client_second -o StrictHostKeyChecking=no mkdir /root/Desktop/iperf_log_$ip_client_second
sshpass -p '123456' ssh root@$ip_client_third -o StrictHostKeyChecking=no rm -rf /root/Desktop/iperf_log_$ip_client_third
sshpass -p '123456' ssh root@$ip_client_third -o StrictHostKeyChecking=no mkdir /root/Desktop/iperf_log_$ip_client_third

sleep 5


gnome-terminal -e "sshpass -p '123456' ssh root@$ip_client -o StrictHostKeyChecking=no iperf -c $ip_host 2>&1 | tee /root/Desktop/iperf_log_$ip_client/$current_time.log" &
gnome-terminal -e "sshpass -p '123456' ssh root@$ip_client_second -o StrictHostKeyChecking=no iperf -c $ip_host 2>&1 | tee /root/Desktop/iperf_log_$ip_client_second/$current_time.log" &
gnome-terminal -e "sshpass -p '123456' ssh root@$ip_client_third -o StrictHostKeyChecking=no iperf -c $ip_host 2>&1 | tee /root/Desktop/iperf_log_$ip_client_third/$current_time.log" &

wait

echo "done"

#syncronize the data
sshpass -p '123456' rsync -avzh root@$ip_client:/root/Desktop/iperf_log_$ip_clent/$current_time.log /root/Desktop/iperf_test_result
sshpass -p '123456' rsync -avzh root@$ip_client_second:/root/Desktop/iperf_log_$ip_client_second/$current_time.log /root/Desktop/iperf_test_result
sshpass -p '123456' rsync -avzh root@$ip_client_third:/root/Desktop/iperf_log_$ip_client_third/$current_time.log /root/Desktop/iperf_test_result

