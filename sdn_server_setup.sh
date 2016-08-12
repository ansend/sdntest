#! /bin/bash

#IP=$(ifconfig)
#echo $IP

eth0ip=$(ifconfig eth0 | grep 'inet addr' | sed 's/^.*addr://g' | sed 's/  Bcast.*$//g')

echo "get the address"
echo $eth0ip

etcdpid=$(pidof 'etcd')
 
if test $( pgrep -f 'etcd' | wc -l ) -eq 0 
        then
        nohup ./etcd -advertise-client-urls "http://$eth0ip:2379,http://$eth0ip:4001 --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001" &
        echo "start etcd on sdn test on server"
else

        kill -2 "$etcdpid"
        nohup ./etcd -advertise-client-urls "http://$eth0ip:2379,http://$eth0ip:4001 --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001" &

fi

 ./etcdctl set /coreos.com/network/config  '{ "Network": "172.17.0.0/16", "SubnetLen": 24, "SubnetMin": "172.17.10.0", "SubnetMax": "172.17.120.0", "Backend": { "Type": "udp"} }' 

flannelpid=$(pidof 'etcd')

if test $( pgrep -f 'flanneld' | wc -l ) -eq 0 
        then
        nohup ./flanneld -etcd-endpoints "http://$eth0ip:4001" &
        echo "start flannel for on sdn server "
else
        kill -2 "$flannelpid"
        nohup ./flanneld -etcd-endpoints "http://$eth0ip:4001"
fi

qperfid=$(pidof 'qperf')


if test $( pgrep -f 'qperf' | wc -l ) -eq 0
        then
        nohup qperf &
        echo "start qperf for on sdn server "
else
        kill -2 "$qperfpid"
        nohup qperf &
fi


