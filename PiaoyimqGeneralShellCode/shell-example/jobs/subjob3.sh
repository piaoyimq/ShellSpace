#!/bin/bash -e




echo "____$0, pid=$$, ppid=$PPID"

sleep 5
start_job ./subjob3-1.sh ./subjob3-1.sh.log  
