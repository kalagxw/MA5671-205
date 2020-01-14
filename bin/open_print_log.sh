#!/bin/ash

# 初始化串口打印跟踪记录，60秒以后关闭记录
echo !path "/var/init_debug.txt" > /proc/wap_proc/tty;
echo !start > /proc/wap_proc/tty;
while true; do
    sleep 60;
    echo !stop > /proc/wap_proc/tty;
    echo !path "/var/console.log" > /proc/wap_proc/tty;
    break;
done &

