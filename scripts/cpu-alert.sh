#!/bin/bash

CPU_THRESHOLD=30
CPU_TEMP=$(top -l 1 | grep "CPU usage") | awk '{ print $5 }'

while true
do
	if [ $CPU_TEMP -ge $CPU_THRESHOLD]; then
		echo "CPU THRESHOLD EXCEEDED"
	fi

	sleep 10
done
