#!/bin/bash
#bash bin/initMaster.sh

MIP="172.80.0.2"
MASTERNAME="master5"
PORT=9087
SUBNET=172.80.0.0/16
NET=Paxos_Network5

docker rm ${MASTERNAME}
docker rmi ${MASTERNAME}
docker network rm ${NET}
docker build --tag ${MASTERNAME} .
docker network create --subnet=${SUBNET} ${NET}

docker run --cap-add=NET_ADMIN --cpuset-cpus="1,2" --memory="8g" --net ${NET} --ip=${MIP} -p ${PORT}:${PORT} -e TYPE="master" -e MADDR=${MIP} -e MPORT=${PORT} -e NREPLICAS=5 --name ${MASTERNAME} ${MASTERNAME} 
#gaiadocker/iproute2 qdisc del dev eth0 root netem

