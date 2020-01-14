#! /bin/sh

help_msg()
{
	echo "ampcmd show queue index: query a queue info by index."
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
    if [ $var -lt 0 ] || [ $var -gt 127 ];then
      echo "ERROR::input para is not right!"
      return 1;
    else
      ampcmd show queue index $1
      return $?
    fi
fi