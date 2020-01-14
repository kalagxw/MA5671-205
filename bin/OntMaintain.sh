#!/bin/sh
if [ 1 -ne $# ]; 
then
    echo "ERROR::input para is not right!"
    return 1;	
else	
	if [ "success" == $1 ];
	then
		maintain success &
	elif [ "fail" == $1 ];
	then
		maintain fail &
	else
	    echo "ERROR::input para is not right!"
		return 1;
	fi
    return $?
fi
