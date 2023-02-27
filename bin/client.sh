#!/bin/bash


  for i in $(seq 1 10); do
        bin/eclientol -maddr 130.245.173.103 -mport 7087 -runtime 300 -id ${i} 2>&1 | tee -a logs/c_${i}.txt ${ALL} >/dev/null &
        #${DIR}/clientmain ${args} -id  2>&1 | tee -a logs/c_${i}.txt ${ALL} >/dev/null &
        echo "> Client $i of ${NCLIENTS} started!"
    done
