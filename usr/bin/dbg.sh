#! /bin/sh

if [ $# -ne 2 ];
then	
	echo "ERROR::input para is not right!"
	exit 1
fi

expr $1 "+" 10 &> /dev/null
if [ $? -ne 0 ];
then
	echo "ERROR::input para is not right!"
	exit 1 
fi

expr $2 "+" 10 &> /dev/null
if [ $? -ne 0 ];
then
	echo "ERROR::input para is not right!"
	exit 1 
fi

if [ $1 -gt 0 -a $1 -lt 4294967295 -a $2 -ge 0 -a $2 -lt 4294967295 ];
then
	Bbspcmd dbg $1 $2
	exit 0
fi

echo "ERROR::input para is not right!"
exit 1
