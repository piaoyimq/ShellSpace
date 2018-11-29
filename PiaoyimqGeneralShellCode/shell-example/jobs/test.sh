#!/bin/bash
set -x
###var=`ps -ef |grep father|grep -v grep |awk '{print $2}'`;if [ ! -z $var ];then pstree -p $var;fi;  ps -ef|grep father|grep -v grep;ps -ef|grep subjob|grep -v grep

for ((i=0;i<10;i++))
do
    echo "_______times_______$i_______________" >> log
    echo "_______times_______$i_______________" >> test.log
    ./father.sh >>log 2>&1
    ps -ef|grep father >> test.log 2>&1
    ps -ef|grep subjob >> test.log 2>&1
done