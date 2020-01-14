#! /bin/sh

if [ $# -ne 1 ];
then
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $1 != "on" -a $1 != "off" ]; 
then
	echo "ERROR::input para is not right!"
	exit 1
fi

Bbspcmd cmd_debug $1
exit 0
