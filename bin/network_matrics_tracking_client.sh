#sudo rm -r nic_info.txt
#sudo rm -r cpu_intr_info.txt
#sudo rm -r softIQR_info.txt
#sudo rm -r netstat_statistics.txt
#sudo rm -r netstat_eno1_statistics.txt
#sudo rm -r SR_queue.txt

while true; do        
##sudo vnstat -l -i eno1 2>&1 | tee -a Overall_netIO.txt #need to run it separately
sudo ethtool --statistics eno1 | grep "tx_discards" 2>&1 | tee -a nic_info_client.txt #need to run it separately
sudo ethtool --statistics eno1 | grep "rx_discards" 2>&1 | tee -a nic_info_client.txt

sudo egrep "CPU|eno1" /proc/interrupts  2>&1 | tee -a cpu_intr_info_client.txt

sudo cat /proc/net/softnet_stat  2>&1 | tee -a softIQR_info_client.txt

sudo netstat -s  2>&1 | tee -a netstat_statistics_client.txt

sudo netstat -i eno1 2>&1 | tee -a netstat_eno1_statistics_client.txt

sudo ss  -npt 2>&1 | tee -a SR_queue_client.txt

sleep 1

done