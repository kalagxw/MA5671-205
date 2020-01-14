#! /bin/sh

#debug fw pktinfo num	Bbspcmd fw dbg pktinfo info
if [ $# -ne 1 ];
then
	echo "ERROR::input para is not right!"
	exit 1
fi

expr $1 "+" 10 &> /dev/null
if [ $? -eq 0 ];
then
	if [ $1 -ge 0 -a $1 -le 100 ];
	then	
		Bbspcmd fw dbg pktinfo info $1
		exit 0		
	fi	
fi

echo "ERROR::input para is not right!"	
exit 1

