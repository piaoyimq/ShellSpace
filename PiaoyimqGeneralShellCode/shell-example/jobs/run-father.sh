#!/bin/bash

source /home/azhweib/repo/em-360/common/bash/src/basic-function.sh

export SUBJOBS_STATUS_LOG="/proj/public/.tmp/em360/logs/jobs-status.log"

excute_cmd_with_root "true > $SUBJOBS_STATUS_LOG"
tail -f  $SUBJOBS_STATUS_LOG &

bash -x ./father.sh >& ./father.log

kill_jobs