#!/bin/bash -e
set -x
subjob_init $0 $$

#echo "forever: PID of this script: $$"
#echo "forever: PPID of this script: $PPID"
#asfd
#exit 74
#sleep 5
sleep 5
./subjob2-1.sh&
./subjob2-2.sh&
#echo "____$0, pid=$$, ppid=$PPID"
#while :; do       #: equal true.
#    sleep 3
#    asfd
#done