#!/bin/bash

#running swarm init and making zoo-003 the manager
docker swarm init

#copy the joining command from zoo-003 and run it to zoo-004 to make it
#member of swarm

#check the number of node in the swarm .we have to run it inzoo-003
docker node ls

#creating the network in zoo-003
docker network create -d overlay --scope=swarm --attachable overnet

#inspecting the overnet network in zoo-003
docker network inspect overnet




















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


#sudo sysctl -w net.core.wmem_max=12582912

#sudo sysctl -w net.core.rmem_max=12582912

#sudo sysctl -w net.ipv4.tcp_rmem="10240 12582912 12582912"

#sudo sysctl -w net.ipv4.tcp_wmem="10240 12582912 12582912"

#sudo sysctl -w net.ipv4.udp_mem="10240 12582912 12582912"

#sudo sysctl -w net.ipv4.tcp_window_scaling=1

#sudo sysctl -w net.ipv4.tcp_sack=1

#sudo sysctl -w net.ipv4.tcp_no_metrics_save=1

#sudo sysctl -w net.core.netdev_max_backlog=100000

#sudo ip link show
#sudo tc qdisc replace dev eth0 root  pfifo_fast
#  ip link set eth0 qlen 500000

#  sysctl -w net.ipv4.tcp_max_syn_backlog = 12582912

#nload

#tmux 


#ss -plnt sport 5020 to see

#sudo ethtool -g eno1   see the interface ring buffer size
#sudo ethtool -G eno1 tx 511      setting the interface ring buffer size
#sudo ethtool -c eno1  seeing the coalesce parameter
#sudo ethtool -C eno1 rx-usecs 72  setting the value of the rx-usecs

#sudo ethtool -C eno1 tx-usecs 122      standard value
#sudo ethtool -C eno1 rx-usecs 62        standard value


#docker system prune   //to delete all unused docker info

# sudo tc qdisc add dev eno1 root netem delay 100ms
#sudo tc qdisc delete dev eno1 root netem delay 100ms
#docker exec server1 tc qdisc add dev eth0 root netem delay 1ms
#go build -o master ./src/master
#./master
#lsof -nti:7087 | xargs kill -9
#go tool pprof server cpu.prof
#export CPUPROFILE_FREQUENCY=100