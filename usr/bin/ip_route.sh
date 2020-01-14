#! /bin/sh
#ip route

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    exit 1
else
    ip route show
    exit 0
fi