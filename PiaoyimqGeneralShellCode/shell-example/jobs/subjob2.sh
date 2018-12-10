#!/bin/bash -e
set -x




sleep 5
start_job ./subjob2-1.sh
start_job ./subjob2-2.sh
echo "____$0, pid=$$, ppid=$PPID"
