#! /bin/sh  
#traceroute

if [ $# -eq 0 ];
then
    echo "ERROR::input para is not right!"
exit 1
fi

traceroute $*
exit $?
