#! /bin/bash

if [ $# -lt 1 ];then
                echo "usage: `basename $0` serverip"
                        exit
fi

serverip=$1

date=$(date +"%Y-%m-%d-%H-%M.%S")

log_file="sslog_$date"

echo "ss log file" ${log_file}

factorial=1

for a in `seq 1 200`

do
#	echo "start ss call"
	ss -it dst "$serverip"  >> $log_file
	echo $(date +"%Y-%m-%d %H:%M:%S") >> $log_file

	sleep 1
done



