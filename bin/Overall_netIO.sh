sudo rm -r overall_netIO.txt        
        
sudo vnstat -l --style 0 -i eno1 2>&1 | tee -a Overall_netIO.txt #need to run it separately
