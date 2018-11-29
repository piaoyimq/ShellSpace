#!/bin/bash -e
set -x

#subjob_init $0 $$

#echo "forever: PID of this script: $$"
#echo "forever: PPID of this script: $PPID"
#asfd
#exit 74
#sleep 5

echo "____$0, pid=$$, ppid=$PPID"

sleep 5
start_job ./subjob3-1.sh 
