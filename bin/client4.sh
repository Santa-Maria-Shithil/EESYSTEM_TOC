#!/bin/bash
#bash bin/initClient.sh

MIP="172.79.0.2"
MASTERNAME="master4"
MASTERPORT=8087
CLIENTNAME="client4"  #modify client name
CLIENTIP="172.79.0.20" #ip start with IP address 172.75.0.200
CLIENTPORT=8098 #port start with 7270
NCLIENTS=30 # minimum 1
NREQ=50000 # total number of req per client
docker stop ${CLIENTNAME}
docker rm ${CLIENTNAME}
docker rmi ${CLIENTNAME}
docker build --tag ${CLIENTNAME} .
docker run --cpuset-cpus="23-63" --memory="8g" --net Paxos_Network4 --ip=${CLIENTIP} -p ${CLIENTPORT}:${CLIENTPORT} -d -e MADDR=${MIP} -e MPORT=${MASTERPORT} -e Q=${NREQ} -e NCLIENTS=${NCLIENTS} -e TYPE="client" --name ${CLIENTNAME} ${CLIENTNAME}



















