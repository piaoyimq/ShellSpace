#!/bin/sh
##kill all processes for cpic_top.sh/re_top.sh
#Modified by Spenser Sheng.
#TOOLS00001936:Similar functionallity for cpic top is needed for RE.
processes=`ps | grep cpic_top.sh |grep -v grep| awk '{print $1}'`
for process in $processes
do
    kill $process
    echo $process
done
kill `ps aux | grep re_top.sh | grep -v grep|awk '{print $2}'`
kill `ps aux | grep ncpic_top.sh | grep -v grep|awk '{print $2}'`