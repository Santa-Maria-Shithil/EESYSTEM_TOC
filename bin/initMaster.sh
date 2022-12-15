#!/bin/bash
#bash bin/initMaster.sh

MIP="172.80.0.2"
MASTERNAME="master5"
docker rm ${MASTERNAME}
docker rmi ${MASTERNAME}
docker network rm Paxos_Network5
docker build --tag ${MASTERNAME} .
docker network create --subnet=172.80.0.0/16 Paxos_Network5
docker run --cpuset-cpus="1,2" --memory="8g" --net Paxos_Network5 --ip=${MIP} -p 9087:9087 -e TYPE="master" -e MADDR=${MIP} -e MPORT=9087 -e NREPLICAS=5 --name ${MASTERNAME} ${MASTERNAME} 