#! /bin/sh

if [ $# -ne 1 ];
then	
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $1 != "all" -a $1 != "timer" -a $1 != "event" -a $1 != "lsw" -a $1 != "napt" -a $1 != "fwd" ]; 
then	
	echo "ERROR::input para is not right!"
	exit 1
fi

Bbspcmd ffwd dbg  $1
exit 0
