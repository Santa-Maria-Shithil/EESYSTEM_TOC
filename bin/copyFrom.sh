#!/bin/bash
sudo rm -r logs1
sudo mkdir logs1
#sudo mkdir logs2
#sudo mkdir logs3
#sudo mkdir logs4
#sudo mkdir logs5

for i in {1..40}
do
   sudo docker cp client1:/copilot/client-${i}.throughput.txt /home/users/sshithil/copilot/logs1/client-${i}.throughput.txt
   sudo docker cp client1:/copilot/client-${i}.latency.all.txt /home/users/sshithil/copilot/logs1/client-${i}.latency.all.txt
   sudo docker cp client1:/copilot/client-${i}.latency.orig.txt /home/users/sshithil/copilot/logs1/client-${i}.latency.orig.txt
sudo docker cp client1:/copilot/client-${i}.latency.percentiles.txt /home/users/sshithil/copilot/logs1/client-${i}.latency.percentiles.txt
sudo docker cp client1:/copilot/client-${i}.timestamps.orig.txt /home/users/sshithil/copilot/logs1/client-${i}.timestamps.orig.txt
sudo docker cp client1:/copilot/client-${i}.tputlat.txt /home/users/sshithil/copilot/logs1/client-${i}.tputlat.txt
done

sudo mv cpu_intr_info_client.txt ./logs1
sudo mv  cpuUsage_server.txt ./logs1
sudo mv  mem_usage_server.txt ./logs1
sudo mv  netIO_server.txt ./logs1
sudo mv nic_info_server.txt ./logs1
sudo mv cpu_intr_info_server.txt ./logs1 
sudo mv softIQR_info_server.txt ./logs1
sudo mv netstat_statistics_server.txt ./logs1
sudo mv netstat_eno1_statistics_server.txt ./logs1
sudo mv SR_queue_server.txt ./logs1
sudo mv Overall_cpuUsage_server.txt ./logs1
sudo mv Overall_mem_usage_server.txt ./logs1
sudo mv Overall_netIO_server.txt ./logs1

sudo mv cpuUsage_client.txt ./logs1
sudo mv mem_usage_client.txt ./logs1
sudo mv netIO_client.txt ./logs1
sudo mv nic_info_client.txt ./logs1
sudo mv cpu_intr_info_client.txt ./logs1
sudo mv softIQR_info_client.txt ./logs1
sudo mv netstat_statistics_client.txt ./logs1
sudo mv netstat_eno1_statistics_client.txt ./logs1
sudo mv SR_queue_client.txt ./logs1
sudo mv Overall_cpuUsage_client.txt ./logs1
sudo mv Overall_mem_usage_client.txt ./logs1
sudo mv Overall_netIO_client.txt ./logs1




:'
for i in {1..100}
do
   sudo docker cp client2:/copilot/client-${i}.throughput.txt /home/users/sshithil/copilot/logs2/client-${i}.throughput.txt
   sudo docker cp client2:/copilot/client-${i}.latency.all.txt /home/users/sshithil/copilot/logs2/client-${i}.latency.all.txt
   sudo docker cp client2:/copilot/client-${i}.latency.orig.txt /home/users/sshithil/copilot/logs2/client-${i}.latency.orig.txt
sudo docker cp client2:/copilot/client-${i}.latency.percentiles.txt /home/users/sshithil/copilot/logs2/client-${i}.latency.percentiles.txt
sudo docker cp client2:/copilot/client-${i}.timestamps.orig.txt /home/users/sshithil/copilot/logs2/client-${i}.timestamps.orig.txt
sudo docker cp client2:/copilot/client-${i}.tputlat.txt /home/users/sshithil/copilot/logs2/client-${i}.tputlat.txt
done

for i in {1..100}
do
   sudo docker cp client3:/copilot/client-${i}.throughput.txt /home/users/sshithil/copilot/logs3/client-${i}.throughput.txt
   sudo docker cp client3:/copilot/client-${i}.latency.all.txt /home/users/sshithil/copilot/logs3/client-${i}.latency.all.txt
   sudo docker cp client3:/copilot/client-${i}.latency.orig.txt /home/users/sshithil/copilot/logs3/client-${i}.latency.orig.txt
sudo docker cp client3:/copilot/client-${i}.latency.percentiles.txt /home/users/sshithil/copilot/logs3/client-${i}.latency.percentiles.txt
sudo docker cp client3:/copilot/client-${i}.timestamps.orig.txt /home/users/sshithil/copilot/logs3/client-${i}.timestamps.orig.txt
sudo docker cp client3:/copilot/client-${i}.tputlat.txt /home/users/sshithil/copilot/logs3/client-${i}.tputlat.txt
done

for i in {1..100}
do
   sudo docker cp client4:/copilot/client-${i}.throughput.txt /home/users/sshithil/copilot/logs4/client-${i}.throughput.txt
   sudo docker cp client4:/copilot/client-${i}.latency.all.txt /home/users/sshithil/copilot/logs4/client-${i}.latency.all.txt
   sudo docker cp client4:/copilot/client-${i}.latency.orig.txt /home/users/sshithil/copilot/logs4/client-${i}.latency.orig.txt
sudo docker cp client4:/copilot/client-${i}.latency.percentiles.txt /home/users/sshithil/copilot/logs4/client-${i}.latency.percentiles.txt
sudo docker cp client4:/copilot/client-${i}.timestamps.orig.txt /home/users/sshithil/copilot/logs4/client-${i}.timestamps.orig.txt
sudo docker cp client4:/copilot/client-${i}.tputlat.txt /home/users/sshithil/copilot/logs4/client-${i}.tputlat.txt
done


for i in {1..100}
do
   sudo docker cp client5:/copilot/client-${i}.throughput.txt /home/users/sshithil/copilot/logs5/client-${i}.throughput.txt
   sudo docker cp client5:/copilot/client-${i}.latency.all.txt /home/users/sshithil/copilot/logs5/client-${i}.latency.all.txt
   sudo docker cp client5:/copilot/client-${i}.latency.orig.txt /home/users/sshithil/copilot/logs5/client-${i}.latency.orig.txt
sudo docker cp client5:/copilot/client-${i}.latency.percentiles.txt /home/users/sshithil/copilot/logs5/client-${i}.latency.percentiles.txt
sudo docker cp client5:/copilot/client-${i}.timestamps.orig.txt /home/users/sshithil/copilot/logs5/client-${i}.timestamps.orig.txt
sudo docker cp client5:/copilot/client-${i}.tputlat.txt /home/users/sshithil/copilot/logs5/client-${i}.tputlat.txt
done
'