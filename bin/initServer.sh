#!/bin/bash
#bash bin/initServer.sh
MIP="172.79.0.2"
MASTERNAME="master4"
MASTERPORT=8087
SERVERNAME="server4.3"  #modify serer name
SERVERIP="172.79.0.6" #ip start with IP address 172.76.0.4
SERVERPORT=8092 #port start with 5090
NET=Paxos_Network4 #network name start with Paxos_Network1

docker rm ${SERVERNAME}
docker rmi ${SERVERNAME}
docker build --tag ${SERVERNAME} .

#update cpus 19-22,3-7,7-10,15-18
docker run --cpuset-cpus="7-10" --memory="8g" --net ${NET} --ip=${SERVERIP} -p ${SERVERPORT}:${SERVERPORT} -e MADDR=${MIP} -e MPORT=${MASTERPORT} -e SADDR=${SERVERIP} -e SPORT=${SERVERPORT} -e TYPE="server" --name ${SERVERNAME} ${SERVERNAME}
