#!/bin/bash


  for i in $(seq 1 30); do
        bin/eclientol -maddr 130.245.173.103 -mport 7087 -q 50000 -c 0 -runtime 100 -target_rps 1000 -id ${i} 2>&1 | tee -a logs/c_${i}.txt ${ALL} >/dev/null &
        #${DIR}/clientmain ${args} -id  2>&1 | tee -a logs/c_${i}.txt ${ALL} >/dev/null &
        echo "> Client $i of ${NCLIENTS} started!"
    done
