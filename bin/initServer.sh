#!/bin/bash
#bash bin/initServer.sh
MIP="172.78.0.2"
MASTERNAME="master2"
MASTERPORT=7087
SERVERNAME="server3.1"  #modify serer name
SERVERIP="172.78.0.4" #ip start with IP address 172.76.0.4
SERVERPORT=7090 #port start with 5090
docker rm ${SERVERNAME}
docker rmi ${SERVERNAME}
docker build --tag ${SERVERNAME} .

#update cpus 19-26
docker run --cpuset-cpus="19-26" --memory="32g" --net Paxos_Network3 --ip=${SERVERIP} -p ${SERVERPORT}:${SERVERPORT} -e MADDR=${MIP} -e MPORT=${MASTERPORT} -e SADDR=${SERVERIP} -e SPORT=${SERVERPORT} -e TYPE="server" --name ${SERVERNAME} ${SERVERNAME}
