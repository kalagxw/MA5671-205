#! /bin/sh

if [ 0 -ne $# ];
then
    echo "ERROR::input para is not right!"
    return 1;
else
    ampcmd show car all
    return $?
fi