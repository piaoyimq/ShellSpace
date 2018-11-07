#!/bin/bash -e
set -x

source ./start-job.sh

subjob_init $0 $$
echo "____$0, pid=$$, ppid=$PPID"
pre_jobs "$0"

./subjob1.sh &
./subjob2.sh &
./subjob3.sh &
wait_subjob

