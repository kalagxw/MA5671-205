#! /bin/sh

#display fw all			Bbspcmd fw show all
#display fw statistic	Bbspcmd fw show stats

if [ $# -ne 1 ];
then
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $1 != "all" -a $1 != "stats" ]; 
then
	echo "ERROR::input para is not right!"	
	exit 1
fi

Bbspcmd fw show $1
exit 0
