#! /bin/sh
#get iptables raw

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    exit 1
else
    iptables -t raw -nvL
    exit 0
fi