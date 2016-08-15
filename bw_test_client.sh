#! /bin/bash

if [ $# -lt 2 ];then
                echo "usage: `basename $0` tcp_mem_max serverip"
                        exit
fi

date=$(date +"%Y-%m-%d-%H-%M.%S")

log_file=qperf_bw_${date}

tcp_mem_max=$1

serverip=$2

tcp_mem_default=`expr $tcp_mem_max / 2`

echo ${tcp_mem_max}

echo ${tcp_mem_default}

echo ${tcp_mem_default} ${tcp_mem_max} > /proc/sys/net/ipv4/tcp_rmem
echo ${tcp_mem_default} ${tcp_mem_max} > /proc/sys/net/ipv4/tcp_wmem

nohup qperf $serverip -m 64K -t 100 tcp_bw >$log_file 2>&1 &


