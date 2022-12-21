#!/bin/bash
#bash bin/initServer.sh
MIP="172.77.0.2"
MASTERNAME="master2"
MASTERPORT=6087
SERVERNAME="server2.4"  #modify serer name
SERVERIP="172.77.0.7" #ip start with IP address 172.76.0.4
SERVERPORT=6093 #port start with 5090
NET=Paxos_Network2 #network name start with Paxos_Network1

docker rm ${SERVERNAME}
docker rmi ${SERVERNAME}
docker build --tag ${SERVERNAME} .

#update cpus 35-42
docker run --cpuset-cpus="15-18" --memory="8g" --net ${NET} --ip=${SERVERIP} -p ${SERVERPORT}:${SERVERPORT} -e MADDR=${MIP} -e MPORT=${MASTERPORT} -e SADDR=${SERVERIP} -e SPORT=${SERVERPORT} -e TYPE="server" --name ${SERVERNAME} ${SERVERNAME}
