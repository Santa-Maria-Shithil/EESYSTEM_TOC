sudo ip link set eno1 qlen 50000
sudo sysctl -w  net.core.somaxconn=16777216  #32MB
sudo sysctl -w net.core.netdev_max_backlog=16777216
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=16777216

#sudo sysctl -w net.core.wmem_max=134217728

#sudo sysctl -w net.core.rmem_max=134217728

#sudo sysctl -w net.ipv4.tcp_rmem="10240 12582912 134217728"

#sudo sysctl -w net.ipv4.tcp_wmem="10240 12582912 134217728"

#sudo sysctl -w net.ipv4.tcp_window_scaling=1

#sudo sysctl -w net.ipv4.tcp_sack=1

#sudo sysctl -w net.ipv4.tcp_no_metrics_save=1
