#sudo rm -r netIO.txt

i=0
while true; do
        
        docker stats --no-stream --format "{{.Name}}:{{.NetIO}}" 2>&1 | tee -a netIO_client.txt 
        #sudo nethogs  -t -d 1 -c 2| grep "sshithil"
       # sudo vnstat -l --style 0 -i eno1 2>&1 | tee -a Overall_netIO.txt #need to run it separately
     
    done


