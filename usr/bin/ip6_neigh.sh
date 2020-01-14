#! /bin/sh
#ip -6 neigh

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    exit 1
else
    ip -6 neigh show
    exit 0
fi