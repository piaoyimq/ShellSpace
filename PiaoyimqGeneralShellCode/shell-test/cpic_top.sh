#!/bin/sh
# Save PIC top output to file

FILE=/var/crash/`hostname`_top.txt
cat /dev/null > $FILE


while true
do
date "+%F %T.%N" >> $FILE
    # -b    Batch mode
    # -S    Show kernel processes
    # -H    Show threads
    # -s n  Interval
    # -d n  Number iterations 
    # n     Number of lines (processes)
    #
    top -b -S -d 1 100 >> $FILE
sleep 30
done
