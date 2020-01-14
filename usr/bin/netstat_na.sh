#! /bin/sh
#netstat -na

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    exit 1
else
    netstat -na
    exit 0
fi