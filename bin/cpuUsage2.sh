sudo rm -r cpuUsage.txt
i=0
while true; do
        #mpstat -P 1,2,3,4,5,6,7,8,9,10,11,12,13,14  2>&1 | tee -a cpuUsage.txt
        #mkdir -p cpuInfo/
        #docker stats --format "{{.Container}}: {{.CPUPerc}}"
        #sudo docker stats --format "{{.Name}}: {{.CPUPerc}}" 2>&1 | tee -a cpuUsage.txt 

        sudo docker stats --no-stream --format "{{.Name}}:{{.CPUPerc}}" 2>&1 | tee -a cpuUsage.txt 
        
        #sleep 1
       # echo q | htop -d 10| aha --black --line-fix > cpuInfo/htop${i}.html
       # ((i=i+1))
    done