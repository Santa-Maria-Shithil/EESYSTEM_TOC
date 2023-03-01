sudo ip link set eno1 qlen 500000
sudo sysctl  net.core.somaxconn=134217728  #32MB
sudo sysctl net.core.netdev_max_backlog=134217728
sudo sysctl net.ipv4.tcp_max_syn_backlog=134217728
