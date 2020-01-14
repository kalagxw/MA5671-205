#!/bin/sh

if [ $# -ne 3 ];
then
	echo "ERROR::input para num error";
	return 1;
fi

if [ $1 != "start" -a $1 != "stop" ];
then	
	echo "ERROR::input para 1 error"
	return 1;
fi

if [ $2 != "/var/dnsmasq_br0.conf" -a $2 != "/var/dnsmasq_br0_0.conf" -a  $2 != "/var/dnsv6/dnsmasq_br0.conf" ];
then	
	echo "ERROR::input para 2 error"
	return 1;
fi

if [ $1 == "stop" -a $3 != "0" ] ; then
    kill -9 $3;
fi

cmd=`ps |grep $2 |grep -v grep |grep -v /bin/sh`;
if [ "$cmd" == "" -a $1 == "start" ] ; then
    dnsmasq --conf-file=$2 &
fi 

cnt=0
while true; do 
	sleep 0.1
	cmd=`ps |grep $2 |grep -v grep |grep -v /bin/sh`;
	cnt=$(( $cnt + 1 ))
	if [ $cnt == 20 ] ; then
	    echo "ERROR::dnsmasq process always up!"
	    break;
    fi
    if [ "$cmd" == "" -a $1 == "stop" ] ; then       
       break;
    fi
    if [ "$cmd" != "" -a $1 == "start" ] ; then
       break;
    fi
done

exit
