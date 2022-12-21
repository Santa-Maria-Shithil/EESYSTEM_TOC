#!/bin/bash
#bash bin/initServer.sh
MIP="172.78.0.2"
MASTERNAME="master3"
MASTERPORT=7087
SERVERNAME="server3.2"  #modify serer name
SERVERIP="172.78.0.5" #ip start with IP address 172.76.0.4
SERVERPORT=7091 #port start with 5090
NET=Paxos_Network3 #network name start with Paxos_Network1

docker rm ${SERVERNAME}
docker rmi ${SERVERNAME}
docker build --tag ${SERVERNAME} .

#update cpus 35-42
docker run --cpuset-cpus="7-10" --memory="8g" --net ${NET} --ip=${SERVERIP} -p ${SERVERPORT}:${SERVERPORT} -e MADDR=${MIP} -e MPORT=${MASTERPORT} -e SADDR=${SERVERIP} -e SPORT=${SERVERPORT} -e TYPE="server" --name ${SERVERNAME} ${SERVERNAME}
