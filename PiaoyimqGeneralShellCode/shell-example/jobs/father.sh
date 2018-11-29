#!/bin/bash -e
set -x

source ./start-job.sh

subjob_init $0 $$
echo "____$0, pid=$$, ppid=$PPID"
pre_jobs "$0"


start_job ./subjob1.sh
start_job ./subjob2.sh
start_job ./subjob3.sh
start_job ./subjob4.sh


#./subjob1.sh &
#./subjob2.sh &
#./subjob3.sh &
wait_subjob

