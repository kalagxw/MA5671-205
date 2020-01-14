#! /bin/sh

if [ $# -ne 0 ];
then
	echo "ERROR::input para is not right!"
	exit 1
fi

Bbspcmd mac show all
exit 0
