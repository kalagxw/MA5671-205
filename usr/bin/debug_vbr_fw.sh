#! /bin/sh

#debug vbr-fw hook				Bbspcmd vbr-fw dbg hook
#debug vbr-fw vbr-id			Bbspcmd vbr-fw dbg vbr-id [id]
#debug vbr-fw all				Bbspcmd vbr-fw dbg all

if [ $# -ne 1 -a $# -ne 2 ];
then
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $# -eq 1 ];
then
	if [ $1 = "all" -o $1 = "hook" ];
	then
		Bbspcmd vbr-fw dbg $1
		exit 0 
	fi
fi

if [ $# -eq 2 -a $1 = "vbr-id" ];
then
	expr $2 "+" 10 &> /dev/null
	if [ $? -eq 0 ];
	then
		if [ $2 -ge 1 -a $2 -le 16 ];
		then	
			Bbspcmd vbr-fw dbg vbr-id $2	
			exit 0
		fi	
	fi
fi

echo "ERROR::input para is not right!"	
exit 1

