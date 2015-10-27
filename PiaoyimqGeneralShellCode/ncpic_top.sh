#!/bin/sh
# Save NCPIC top output to file
#TOOLS00002120:Top cli command on GGSN NC to track the process and threads on NC when case execution
# Added bu Spenser Sheng.


FILE=/var/crash/`hostname`_nctop.txt
cat /dev/null > $FILE

while true
do
date "+%F %T.%N" >> $FILE
    #
    top -H -t 100 >> $FILE
sleep 10
done
