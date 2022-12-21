#!/bin/bash
#bash bin/initServer.sh
MIP="172.78.0.2"
MASTERNAME="master3"
MASTERPORT=7087
SERVERNAME="server3.1"  #modify serer name
SERVERIP="172.78.0.4" #ip start with IP address 172.76.0.4
SERVERPORT=7090 #port start with 5090
NET=Paxos_Network3 #network name start with Paxos_Network1

docker rm ${SERVERNAME}
docker rmi ${SERVERNAME}
docker build --tag ${SERVERNAME} .

#update cpus 7-10
docker run --cpuset-cpus="19-22" --memory="8g" --net ${NET} --ip=${SERVERIP} -p ${SERVERPORT}:${SERVERPORT} -e MADDR=${MIP} -e MPORT=${MASTERPORT} -e SADDR=${SERVERIP} -e SPORT=${SERVERPORT} -e TYPE="server" --name ${SERVERNAME} ${SERVERNAME}
