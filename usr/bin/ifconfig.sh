#! /bin/sh

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    exit 1
else
    /sbin/ifconfig
fi
