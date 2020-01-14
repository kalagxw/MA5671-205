#!/bin/sh

if [ $# -ne 3 ];
then
	echo "ERROR::input para num error";
	return 1;
fi

if [ $1 != "upnpdmain" -a $1 != "upnpdslave" ];
then	
	echo "ERROR::input para 1 error"
	return 1;
fi

if [ $2 != "br0" -a $2 != "br0:0" ];
then	
	echo "ERROR::input para 2 error"
	return 1;
fi

if [ $3 -gt 65535 -o $3 -lt 1 ];
then	
	echo "ERROR::input para 3 error"
	return 1;
fi

count=0
cmd=`ps |grep $1 |grep -v grep |grep -v /bin/sh`;
if [ "$cmd" != "" ] ; then
	while true; do 
		sleep 0.1
		count=$(( $count + 1 ))
		if [ $count == 30 ] ; then
	    	echo "ERROR::upnp still exist!"
	    	break;
    		fi
	done &
    killall $1;
fi

cnt=0
while true; do 
	sleep 0.1
	cmd=`ps |grep $1 |grep -v grep |grep -v /bin/sh`;
	cnt=$(( $cnt + 1 ))
	if [ $cnt == 20 ] ; then
	    echo "ERROR::upnp process always up!"
	    break;
    fi
    if [ "$cmd" == "" ] ; then
       $1 !br+ $2 $3
       break;
    fi
done &

exit
