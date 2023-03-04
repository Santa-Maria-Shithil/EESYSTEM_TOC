#sudo rm -r cpuUsage.txt


i=0
while true; do
        #mpstat -P 1,2,3,4,5,6,7,8,9,10,11,12,13,14  2>&1 | tee -a cpuUsage.txt
        #mkdir -p cpuInfo/
        #docker stats --format "{{.Container}}: {{.CPUPerc}}"
        #sudo docker stats --format "{{.Name}}: {{.CPUPerc}}" 2>&1 | tee -a cpuUsage.txt 

        sudo docker stats --no-stream --format "{{.Name}}:{{.CPUPerc}}" 2>&1 | tee -a  cpuUsage_client.txt 

        #sudo top -bn1  | grep "server" 2>&1 | tee -a  cpuUsage.txt 

        #sudo top -bn1 | grep "Cpu(s)" |sed "s/.*, *\([0-9.]*\)%* id.*/\1/" |awk '{print 100 - $1}' 2>&1 | tee -a Overall_cpuUsage.txt 
        
        sleep 1
       # echo q | htop -d 10| aha --black --line-fix > cpuInfo/htop${i}.html
       # ((i=i+1))

       #for i in {1..4}; do sleep 1 && top -b -p 8981,842397 -n 1 | tail -1 ; done >> cron.txt
    done