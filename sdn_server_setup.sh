#! /bin/bash

#IP=$(ifconfig)
#echo $IP

eth0ip=$(ifconfig eth0 | grep 'inet addr' | sed 's/^.*addr://g' | sed 's/  Bcast.*$//g')

echo "get the address"
echo "eth0 ip address" $eth0ip

etcdpid=$(pidof 'etcd')

echo "existing etcd pid" $etcdpid

if test $( pidof 'etcd' | wc -l ) -eq 0 
        then
            #echo "./etcd -advertise-client-urls http://$eth0ip:2379,http://$eth0ip:4001 --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001"
        nohup ./etcd -advertise-client-urls "http://$eth0ip:2379,http://$eth0ip:4001" --listen-client-urls "http://0.0.0.0:2379,http://0.0.0.0:4001" > etcdlog 2>&1 &
        echo "start etcd on sdn test on server"
else

        kill -9 ${etcdpid}
        nohup ./etcd -advertise-client-urls "http://$eth0ip:2379,http://$eth0ip:4001" --listen-client-urls "http://0.0.0.0:2379,http://0.0.0.0:4001" > etcdlog 2>&1 &
                echo "restart etcd on sdn test on server"
fi

sleep 2  #sleep to wait etcd server come up

 ./etcdctl set  /coreos.com/network/config  '{ "Network": "172.17.0.0/16", "SubnetLen": 24, "SubnetMin": "172.17.10.0", "SubnetMax": "172.17.120.0", "Backend": { "Type": "udp"} }' 

flannelpid=$(pidof 'flanneld')

if test $( pidof 'flanneld' | wc -l ) -eq 0 
        then
        nohup ./flanneld -etcd-endpoints "http://$eth0ip:4001" > flannellog 2>&1 &
        echo "start flannel for on sdn server "
else
            kill -2 ${flannelpid}
        kill -9 ${flannelpid}
        nohup ./flanneld -etcd-endpoints "http://$eth0ip:4001" > flannellog 2>&1 &
                echo "restart flanneld on server side"
fi

qperfpid=$(pidof 'qperf')


if test $( pgrep -f 'qperf' | wc -l ) -eq 0
        then
        nohup qperf > qperflog 2>&1 &
        echo "start qperf for on sdn server "
else
        kill -9 ${qperfpid}
        nohup qperf > qperflog 2>&1 &
                echo "restart qperf for on sdn server "
fi

