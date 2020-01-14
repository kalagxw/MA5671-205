#! /bin/sh
#ip rule

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    exit 1
else
    ip rule show
    exit 0
fi