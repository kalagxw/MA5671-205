#!/bin/ash

# ��ʼ�����ڴ�ӡ���ټ�¼��60���Ժ�رռ�¼
echo !path "/var/init_debug.txt" > /proc/wap_proc/tty;
echo !start > /proc/wap_proc/tty;
while true; do
    sleep 60;
    echo !stop > /proc/wap_proc/tty;
    echo !path "/var/console.log" > /proc/wap_proc/tty;
    break;
done &

