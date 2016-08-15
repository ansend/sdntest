#! /bin/bash
if [ $# -lt 1 ];then
        echo "usage: `basename $0` etcdip"
            exit
fi

pid=$(pidof 'flanneld')

etcdurl=$1

echo "etcd ip address" $etcdurl

if test $( pidof 'flanneld' | wc -l ) -eq 0
    then
    nohup ./flanneld -etcd-endpoints "http://$etcdurl:4001" >flannel_log 2>&1 &
    echo "start sdn client node for test" "./flanneld -etcd-endpoints http://$etcdurl:4001"
else
    kill -2 ${pid}
    kill -9 ${pid}
    nohup ./flanneld -etcd-endpoints "http://$etcdurl:4001" >flannel_log 2>&1 &
    echo "restart sdn client node for test" "./flanneld -etcd-endpoints http://$etcdurl:4001"
fi
