#!/bin/bash
#set -x

length=$#
usage() {
    echo "Usage: cat-alarm.sh <alarm-history-filename> <'Fault Id' | 'Specific Problem'>
    cat-alarm.sh alarm-history 380733 
    cat-alarm.sh alarm-history 'Session Resilience Not Established for PSC'"
    exit 65
}

if [ $length != 2 ]
then
    usage
fi

if [ $2 -ge 0 ]
then
    cat $1|grep -w -B 1 -A 9 "Fault Id: $2"
else
    cat $1|grep -w -B 4 -A 6 "Specific Problem: $2"
fi
