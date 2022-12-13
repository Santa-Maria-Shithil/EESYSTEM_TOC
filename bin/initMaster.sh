#!/bin/bash
#bash bin/initMaster.sh

MIP="172.76.0.2"
MASTERNAME="master1"
docker rm ${MASTERNAME}
docker rmi ${MASTERNAME}
docker network rm Paxos_Network1
docker build --tag ${MASTERNAME} .
docker network create --subnet=172.76.0.0/16 Paxos_Network1
docker run --cpuset-cpus="1,2" --memory="8g" --net Paxos_Network1 --ip=${MIP} -p 5087:5087 -e TYPE="master" -e MADDR=${MIP} -e MPORT=5087 -e NREPLICAS=3 --name ${MASTERNAME} ${MASTERNAME} sh