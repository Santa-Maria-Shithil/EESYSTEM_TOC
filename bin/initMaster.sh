#!/bin/bash
#bash bin/initMaster.sh

MIP="10.0.1.100"
MASTERNAME="master5"
PORT=9087
SUBNET=10.0.1.0/24
NET=overnet

docker rm ${MASTERNAME}
docker rmi ${MASTERNAME}
#docker network rm -d ${NET}
docker build --tag ${MASTERNAME} .
#docker network create --subnet=${SUBNET} ${NET}
#docker network create  -d overlay --attachable overnet


docker run  --privileged --cpuset-cpus="1,2" --memory="8g" --net ${NET} --ip=${MIP} -p ${PORT}:${PORT} --cap-add=NET_ADMIN --sysctl=net.core.somaxconn=12582912 --sysctl=net.ipv4.tcp_max_syn_backlog=12582912 --sysctl=net.core.netdev_max_backlog=12582912 -e TYPE="master" -e MADDR=${MIP} -e MPORT=${PORT} -e NREPLICAS=5 --name ${MASTERNAME} ${MASTERNAME} 
#gaiadocker/iproute2 qdisc del dev eth0 root netem

