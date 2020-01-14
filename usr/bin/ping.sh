#! /bin/sh  
#ping

if [ $# -eq 0 ];
then
    echo "ERROR::input para is not right!"
exit 1
fi

ping $*
exit $?
