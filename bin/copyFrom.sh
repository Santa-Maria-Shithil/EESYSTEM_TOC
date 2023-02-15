#!/bin/bash
sudo rm -r logs
sudo mkdir logs
#sudo mkdir logs2
#sudo mkdir logs3
#sudo mkdir logs4
#sudo mkdir logs5

for i in {1..100}
do
   sudo docker cp client1:/copilot/client-${i}.throughput.txt /home/users/sshithil/copilot/logs/client-${i}.throughput.txt
   sudo docker cp client1:/copilot/client-${i}.latency.all.txt /home/users/sshithil/copilot/logs/client-${i}.latency.all.txt
   sudo docker cp client1:/copilot/client-${i}.latency.orig.txt /home/users/sshithil/copilot/logs/client-${i}.latency.orig.txt
sudo docker cp client1:/copilot/client-${i}.latency.percentiles.txt /home/users/sshithil/copilot/logs/client-${i}.latency.percentiles.txt
sudo docker cp client1:/copilot/client-${i}.timestamps.orig.txt /home/users/sshithil/copilot/logs/client-${i}.timestamps.orig.txt
sudo docker cp client1:/copilot/client-${i}.tputlat.txt /home/users/sshithil/copilot/logs/client-${i}.tputlat.txt
done
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