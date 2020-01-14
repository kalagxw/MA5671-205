#! /bin/sh

help_msg()
{
	echo "ampcmd show flow index: query a flow info by index."
}

if [ $# -ne 1 ];
then
	echo "ERROR::input para is not right!";
	return 1;
fi

#check is num
expr $1 "+" 10 &> /dev/null
if [ $? -ne 0 ];
then
	echo "ERROR::input para is not right!";
	return 1;
fi

if [ "$1" != "" ];then
let var=$1;
fi

if [ "$1" = "-h" ];then
  help_msg
  return $?
else
    if [ $var -lt 0 ] || [ $var -gt 31 ];then
      echo "ERROR::input para is not right!"
      return 1;
    else
      ampcmd show flow index $1
      return $?
    fi
fi