#!/bin/bash

HOG=$(ps -axo %cpu,pid,comm | sort -nrk 1 | head -n 3)
echo "$HOG"| awk '{ print "CPU:", $1, "PID:", $2, "COMM:", $3 }'

exit 0
