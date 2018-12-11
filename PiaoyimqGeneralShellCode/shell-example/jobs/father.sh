#!/bin/bash -e

#set -x

source ./start-job.sh



pre_jobs "$0" "$$"

start_job ./subjob1.sh "./subjob1.log"
start_job ./subjob2.sh "./subjob2.log"
start_job ./subjob3.sh "./subjob3.log"
start_job ./subjob4.sh "./subjob4.log"


wait_subjob

