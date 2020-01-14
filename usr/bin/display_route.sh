#! /bin/sh
#display route

if [ $# -ne 2 ];
then
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $1 != "show" ]; 
then	
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $2 != "all" -a  $2 != "neigh" -a  $2 != "fib4" -a  $2 != "fib6" ]; 
then	
	echo "ERROR::input para is not right!"
	exit 1
fi

Bbspcmd route show $2
exit 0
