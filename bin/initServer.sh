#!/bin/bash
#bash bin/initServer.sh
MIP="172.80.0.2"
MASTERNAME="master5"
MASTERPORT=9087
SERVERNAME="server5.5"  #modify serer name
SERVERIP="172.80.0.8" #ip start with IP address 172.76.0.4
SERVERPORT=9095 #port start with 5090
docker rm ${SERVERNAME}
docker rmi ${SERVERNAME}
docker build --tag ${SERVERNAME} .

#update cpus 35-42
docker run --cpuset-cpus="36-42" --memory="32g" --net Paxos_Network5 --ip=${SERVERIP} -p ${SERVERPORT}:${SERVERPORT} -e MADDR=${MIP} -e MPORT=${MASTERPORT} -e SADDR=${SERVERIP} -e SPORT=${SERVERPORT} -e TYPE="server" --name ${SERVERNAME} ${SERVERNAME}
