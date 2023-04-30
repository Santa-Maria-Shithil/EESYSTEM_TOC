#sudo rm -r Overall_netIO.txt     

while true; do       

vnstat --style 1  -tr 2 -i eno1 2>&1 | tee -a Overall_netIO_server.txt 

done
