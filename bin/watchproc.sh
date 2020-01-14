#!/bin/sh
pid=""
name=""

echo "$1" First Started by WatchProc!
$* &

# ��һ����������ʱ��Ҫ��ʱ60��
sleep 60

while true; do
	# ÿ5����һ��
	sleep 5

	# check pid
	if [ "$1" != "" ]; then
		if [ "$pid" = "" ]; then
			# ���pidΪ�գ�����ȡ��һ��PID
			pid=`pidof $1`
		fi

		if [ "$pid" = "" ]; then
			# �����Ϊ�գ�����������
			echo "$1" Started by WatchProc!
			$* &
		fi

		if [ -f "/proc/$pid/cmdline" ]; then
			# ���PID���ھͲ����ٲ�����
			continue;
		fi

		# PID����Ϊ�գ��´�ѭ���ٲ�ѯ
		pid=""
	fi
done
