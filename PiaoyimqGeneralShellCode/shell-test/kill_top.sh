#!/bin/sh
##kill all processes for cpic_top.sh
processes=`ps | grep -w cpic_top.sh |grep -v grep| awk '{print $1}'`
for process in $processes
do
    kill -9 $process
    echo $process
done
kill -9 `ps aux | grep -w ncpic_top.sh | grep -v grep|awk '{print $2}'`
