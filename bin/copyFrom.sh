#!/bin/bash
for i in {1..90}
do
   sudo docker cp client1:/copilot/client-${i}.throughput.txt /home/users/sshithil/copilot/logs/client-${i}.throughput.txt
   sudo docker cp client1:/copilot/client-${i}.latency.all.txt /home/users/sshithil/copilot/logs/client-${i}.latency.all.txt
   sudo docker cp client1:/copilot/client-${i}.latency.orig.txt /home/users/sshithil/copilot/logs/client-${i}.latency.orig.txt
sudo docker cp client1:/copilot/client-${i}.latency.percentiles.txt /home/users/sshithil/copilot/logs/client-${i}.latency.percentiles.txt
sudo docker cp client1:/copilot/client-${i}.timestamps.orig.txt /home/users/sshithil/copilot/logs/client-${i}.timestamps.orig.txt
sudo docker cp client1:/copilot/client-${i}.tputlat.txt /home/users/sshithil/copilot/logs/client-${i}.tputlat.txt
done