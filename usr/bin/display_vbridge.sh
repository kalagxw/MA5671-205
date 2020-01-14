#! /bin/sh

if [ $# -ne 1 ];
then
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $1 != "info" -a $1 != "uni-binding" -a $1 != "nni-binding" -a $1 != "uplink-binding" -a $1 != "port-binding" ]; 
then
	echo "ERROR::input para is not right!"	
	exit 1
fi

if [ $1 = "info" ];
then
	Bbspcmd vbridge bridge-info
	exit 0
fi

Bbspcmd vbridge $1
exit 0
