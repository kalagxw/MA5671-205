#! /bin/sh

if [ $# -ne 1 ];then
	echo "ERROR::input para is not right!";
	return 1;
	elif [ "$1" = "on" ];then
		ampcmd trace emap on
		return $?
	elif [ "$1" = "off" ];then
    ampcmd trace emap off
    return $? 
  else
    echo "ERROR::input para is not right!"
    return 1;
fi