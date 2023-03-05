#sudo rm -r Overall_mem_usage.txt

while true; do
free -b -s 1 -c 1| grep "Mem" 2>&1 | tee -a Overall_mem_usage_client.txt 
done