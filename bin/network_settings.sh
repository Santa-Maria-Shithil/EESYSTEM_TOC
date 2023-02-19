#!/bin/bash
#echo 'net.core.wmem_max=12582912' >> /home/users/sshithil/sysctl.conf

#echo 'net.core.rmem_max=12582912' >> /home/users/sshithil/sysctl.conf

#echo 'net.ipv4.tcp_rmem= 10240 87380 12582912' >> /home/users/sshithil/sysctl.conf

#echo 'net.ipv4.tcp_wmem= 10240 87380 12582912' >> /home/users/sshithil/sysctl.conf

#echo 'net.ipv4.udp_mem= 10240 87380 12582912' >> /home/users/sshithil/sysctl.conf

#echo 'net.ipv4.tcp_window_scaling = 1' >> /home/users/sshithil/sysctl.conf

#echo 'net.ipv4.tcp_sack = 1' >> /home/users/sshithil/sysctl.conf

#echo 'net.ipv4.tcp_no_metrics_save = 1' >> /home/users/sshithil/sysctl.conf

#echo 'net.core.netdev_max_backlog = 100000' >> /home/users/sshithil/sysctl.conf

#sudo sysctl -p /home/users/sshithil/sysctl.conf


#sudo sysctl net.ipv4.tcp_sack


sudo sysctl -w net.core.wmem_max=12582912

sudo sysctl -w net.core.rmem_max=12582912

sudo sysctl -w net.ipv4.tcp_rmem="10240 12582912 12582912"

sudo sysctl -w net.ipv4.tcp_wmem="10240 12582912 12582912"

sudo sysctl -w net.ipv4.udp_mem="10240 12582912 12582912"

sudo sysctl -w net.ipv4.tcp_window_scaling=1

sudo sysctl -w net.ipv4.tcp_sack=1

sudo sysctl -w net.ipv4.tcp_no_metrics_save=1

sudo sysctl -w net.core.netdev_max_backlog=100000