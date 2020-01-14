#! /bin/sh
#get iptables mangle

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    exit 1
else
    iptables -t mangle -nvL
    exit 0
fi