#! /bin/sh

#vport statistic clear	Bbspcmd vport clean stat [id]

if [ $# -ne 1 ];
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

if [ $1 -lt 1 -o $1 -gt 1024 ];
then	
	echo "ERROR::input para is not right!"		
	exit 1
fi

Bbspcmd vport clean stat  $1
exit 0
