#! /bin/sh
#ip neigh

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    exit 1
else
    ip neigh show
    exit 0
fi