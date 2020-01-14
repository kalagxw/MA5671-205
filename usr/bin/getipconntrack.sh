#! /bin/sh

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    exit 1
else
    cat /proc/net/ip_conntrack
fi
