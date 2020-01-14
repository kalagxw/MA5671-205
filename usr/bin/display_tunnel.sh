#! /bin/sh
#tunnel show all

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    exit 1
else
    Bbspcmd tunnel show all
    exit 0
fi