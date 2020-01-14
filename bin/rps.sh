#! /bin/sh

if [ $# -ne 1 ];
then	
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $1 != "enable" -a $1 != "disable" ]; 
then	
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $1 == "enable" ];
then
	echo 1 > /proc/sys/net/core/rps_switch
else
	echo 0 > /proc/sys/net/core/rps_switch
fi

exit 0
