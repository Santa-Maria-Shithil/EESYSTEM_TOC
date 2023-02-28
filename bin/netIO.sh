sudo rm -r netIO.txt
sudo rm -r overall_netIO.txt
i=0


#!/bin/bash

multiLine="";
format="table {{.Name}}\t{{.CPUPerc}}\t{{.NetIO}";
docker stats --all --format "$format" --no-trunc | (while read line; do
    sedLine=$(echo "$line" | sed "s/^.*name.*cpu.*mem.*$/_divider_/i")
    if [ "$sedLine" != "_divider_" ];
    then
        multiLine="${multiLine}"'\n'"${line}";
    else
        echo -e $multiLine > $1;
        multiLine="";
    fi;
done);








#while true; do
        
       # sudo docker stats --no-stream --format "{{.Name}}:{{.NetIO}}" 2>&1 | tee -a netIO.txt 

       # sudo vnstat -l --style 0 -i eno1 2>&1 | tee -a Overall_netIO.txt #need to run it separately
     
    #done