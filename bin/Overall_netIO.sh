sudo rm -r overall_netIO.txt     

while true; do        
##sudo vnstat -l -i eno1 2>&1 | tee -a Overall_netIO.txt #need to run it separately
sudo vnstat --style 0  -tr 2 -i eno1 2>&1 | tee -a Overall_netIO.txt #need to run it separately

done
