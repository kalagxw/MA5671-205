#!/bin/sh
pid=""
name=""

echo "$1" First Started by WatchProc!
$* &

# 第一次启动进程时，要延时60秒
sleep 60

while true; do
	# 每5秒检测一下
	sleep 5

	# check pid
	if [ "$1" != "" ]; then
		if [ "$pid" = "" ]; then
			# 如果pid为空，就先取得一下PID
			pid=`pidof $1`
		fi

		if [ "$pid" = "" ]; then
			# 如果还为空，就启动进程
			echo "$1" Started by WatchProc!
			$* &
		fi

		if [ -f "/proc/$pid/cmdline" ]; then
			# 如果PID存在就不用再查找了
			continue;
		fi

		# PID设置为空，下次循环再查询
		pid=""
	fi
done
