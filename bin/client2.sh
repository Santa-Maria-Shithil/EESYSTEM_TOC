#!/bin/bash
#bash bin/initClient.sh
MIP="172.77.0.2"
MASTERNAME="master3"
MASTERPORT=6087
CLIENTNAME="client2"  #modify client name
CLIENTIP="172.77.0.20" #ip start with IP address 172.75.0.200
CLIENTPORT=6098 #port start with 7270
NCLIENTS=30 # minimum 1
NREQ=100000 # total number of req per client
docker stop ${CLIENTNAME}
docker rm ${CLIENTNAME}
docker rmi ${CLIENTNAME}
docker build --tag ${CLIENTNAME} .
docker run --cpuset-cpus="23-63" --memory="8g" --net Paxos_Network2 --ip=${CLIENTIP} -p ${CLIENTPORT}:${CLIENTPORT} -d -e MADDR=${MIP} -e MPORT=${MASTERPORT} -e Q=${NREQ} -e NCLIENTS=${NCLIENTS} -e TYPE="client" --name ${CLIENTNAME} ${CLIENTNAME}



















