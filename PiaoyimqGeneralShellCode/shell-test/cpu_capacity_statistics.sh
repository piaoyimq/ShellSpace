#!/bin/sh
pid=`ps -e|egrep "\b$1$" | awk '{print $1}'` #获取进程id
echo "pid: $pid"
cpu=`top -n 1 -p $pid|tail -2|head -1|awk '{ssd=NF-4} {print $ssd}'`
#获取进程cpu占用
echo "cpu: $cpu"
declare -i cpuall=0
declare -i time=0
while [ 1 ]
do
  cpu=`top -n 1 -p $pid|tail -2|head -1|awk '{ssd=NF-4} {print $ssd}'`
  cpuall=cpuall+cpu
  time=time+1
  average=`echo "scale=3;$cpuall/$time" |bc -l`
  #declare -i average=$cpuall/$time
  echo $average
  sleep 1
done
