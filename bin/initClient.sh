#!/bin/bash
#bash bin/initClient.sh
MIP="172.76.0.2"
MASTERNAME="master"
MASTERPORT=5087
CLIENTNAME="client1"  #modify client name
CLIENTIP="172.76.0.20" #ip start with IP address 172.75.0.200
CLIENTPORT=5099 #port start with 5099
NCLIENTS=20 # minimum 1
NREQ=50000 # total number of req per client
docker stop ${CLIENTNAME}
docker rm ${CLIENTNAME}
docker rmi ${CLIENTNAME}
docker build --tag ${CLIENTNAME} .
docker run --cpuset-cpus="13-63" --memory="8g" --net Paxos_Network1 --ip=${CLIENTIP} -p ${CLIENTPORT}:${CLIENTPORT} -e MADDR=${MIP} -e MPORT=${MASTERPORT} -e Q=${NREQ} -e NCLIENTS=${NCLIENTS} -e TYPE="client" --name ${CLIENTNAME} ${CLIENTNAME}


















