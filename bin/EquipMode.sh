#! /bin/sh

if [ 1 -ne $# ]; then
    echo "ERROR::input para is not right!";
    exit 1;
else
    if [ "$1" = "on" ]; then
  cp /bin/Equip.sh /mnt/jffs2/Equip.sh
    elif [ "$1" = "off" ]; then
        rm /mnt/jffs2/Equip.sh
        rm -f /mnt/jffs2/art.ko
        rm -f /mnt/jffs2/mdk_client.out
        rm -f /mnt/jffs2/equiptestmode
    else
        echo "Input para wrong!"
        exit 1;
    fi
fi
sync
sleep 2
echo $1
exit 0
