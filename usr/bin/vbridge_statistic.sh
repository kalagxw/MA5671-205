#! /bin/sh

#display vbridge statistic	Bbspcmd vbr-fw show stat
#vbridge statistic clear	Bbspcmd vbr-fw clean vbr-id


if [ $# -ne 2 ];
then
	echo "ERROR::input para is not right!"
	exit 1
fi

expr $2 "+" 10 &> /dev/null
if [ $? -eq 0 ];
then
	if [ $2 -ge 1 -a $2 -le 16 ];
	then	
		if [ $1 = "show" ];
		then
			Bbspcmd vbr-fw show stat $2
			exit 0
		elif [ $1 = "clear" ]
		then
			Bbspcmd vbr-fw clean vbr-id $2
			exit 0
		fi
	fi	
fi

echo "ERROR::input para is not right!"	
exit 1

