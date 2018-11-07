#!/bin/bash -e
set -x
subjob_init $0 $$

#echo "forever: PID of this script: $$"
#echo "forever: PPID of this script: $PPID"
#asfd
#exit 74
#sleep 5

echo "____$0, pid=$$, ppid=$PPID"
exit 0
asfd
while :; do       #: equal true.
    sleep 5
done