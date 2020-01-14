#! /bin/sh
#ip -6 route

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    exit 1
else
    ip -6 route show
    exit 0
fi