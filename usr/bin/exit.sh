#!/bin/sh

if [ 0 -eq $# ]; then
    exit ;
    return 0;
else
    echo "ERROR::input para is not right!";
    return 1;
fi
