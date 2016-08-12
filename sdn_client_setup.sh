#! /bin/bash

if [ $# -lt 1 ];then
		echo "usage: `basename $0` etcdip"
			exit
fi

pid=$(pidof 'flanneld')

etcdurl=$1

echo "etcd ip address" $etcdurl

if test $( pgrep -f 'flanneld' | wc -l ) -eq 0 
	then
	./flanneld -etcd-endpoints "http://$etcdurl:4001"
	echo "start sdn cient node for test"
else
	kill -2 "$pid"
	./flanneld -etcd-endpoints "http://$etcdurl:4001"
fi	

