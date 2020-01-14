#! /bin/sh
#get iptables filter

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    exit 1
else
    iptables -nvL
    exit 0
fi