#! /bin/sh

if [ $# -ne 0 ];
then	
	echo "ERROR::input para is not right!"
	exit 1
fi

oamcmd oaml2shell show_ethvlan
exit 0
