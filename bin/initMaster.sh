#!/bin/bash
#bash bin/initMaster.sh

MIP="172.76.0.2"
MASTERNAME="master1"
PORT=5087
SUBNET=172.76.0.0/16
NET=Paxos_Network1

docker rm ${MASTERNAME}
docker rmi ${MASTERNAME}
docker network rm ${NET}
docker build --tag ${MASTERNAME} .
docker network create --subnet=${SUBNET} ${NET}
docker run --cpuset-cpus="1,2" --memory="8g" --net ${NET} --ip=${MIP} -p ${PORT}:${PORT} -e TYPE="master" -e MADDR=${MIP} -e MPORT=${PORT} -e NREPLICAS=5 --name ${MASTERNAME} ${MASTERNAME} 