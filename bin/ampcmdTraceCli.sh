#! /bin/sh

if [ $# -ne 1 ];then
	echo "ERROR::input para is not right!";
	return 1;
	elif [ "$1" = "on" ];then
		ampcmd trace cli on
		return $?
	elif [ "$1" = "off" ];then
    ampcmd trace cli off
    return $? 
  else
    echo "ERROR::input para is not right!"
    return 1;
fi