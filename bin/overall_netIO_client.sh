#sudo rm -r Overall_netIO.txt     

while true; do        
##sudo vnstat -l -i eno1 2>&1 | tee -a Overall_netIO.txt #need to run it separately
vnstat --style 1  -tr 2 -i eno1 2>&1 | tee -a Overall_netIO_client.txt #need to run it separately

done
