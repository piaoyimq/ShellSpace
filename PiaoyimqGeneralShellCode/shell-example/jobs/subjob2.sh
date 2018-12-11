#!/bin/bash -e




sleep 5
start_job ./subjob2-1.sh "./subjob2-1.sh.log"
start_job ./subjob2-2.sh "./subjob2-2.sh.log"
echo "____$0, pid=$$, ppid=$PPID"
