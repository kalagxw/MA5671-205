#! /bin/sh

if [ 1 -eq $# ]; then
    killall "$1"
    [ 0 -ne $? ] && exit 1
elif [ 2 -eq $# ]; then
    if [ $1 = "-9" ]; then
        killall -9 "$2"
        [ 0 -ne $? ] && exit 1
    else
        echo "ERROR::input para is not right!"
        exit 1
    fi
else
    echo "ERROR::input para is not right!"
    exit 1
fi

exit 0