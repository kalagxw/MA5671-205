#! /bin/sh

# display ctp all
# display ctp detail id
if [ $# -ne 1 -a $# -ne 2 ];
then
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $# -eq 1 -a $1 = "all" ];
then
	Bbspcmd ctp show_ctp all
	exit 0
fi

if [ $# -eq 2 -a $1 = "detail" ];
then
	expr $2 "+" 10 &> /dev/null
	if [ $? -eq 0 ];
	then
		if [ $2 -ge 1 -a $2 -le 32 ];
		then
			Bbspcmd ctp show_ctp detail $2			
			exit 0 
		fi
	fi
fi

echo "ERROR::input para is not right!"	
exit 1
