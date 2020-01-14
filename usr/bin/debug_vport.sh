#! /bin/sh

if [ $# -ne 1 ];
then
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $1 != "all" -a $1 != "step" ]; 
then	
	echo "ERROR::input para is not right!"
	exit 1
fi

Bbspcmd vport dbg $1
exit 0
