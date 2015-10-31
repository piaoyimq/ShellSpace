#!/bin/sh
#this file working wiht HealthMoniter.sh, and this file locate /etc/init.d/ direcotry.


/home/root/SubProcess &                                                       
/home/root/MainProcess -qws &  

if [ $1 != "Monitor" ]; then
sleep 30

/home/root/HealthMonitor.sh &
fi
