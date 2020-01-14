#! /bin/sh

if [ $# -ne 0 ];
then	
	echo "ERROR::input para is not right!"
	exit 1
fi

Bbspcmd acl show chain all
exit 0
