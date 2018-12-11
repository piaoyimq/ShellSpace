#!/bin/bash -e

set -x

###Usage exmaple:
###pre_jobs "$0" "$$"
###
###start_job ./subjob1.sh
###start_job ./subjob2.sh
###start_job ./subjob3.sh
###start_job ./subjob4.sh
###
###wait_subjob
###




source /home/azhweib/repo/em-360/common/bash/src/basic-function.sh

export -f excute_cmd_with_root
export -f info_log
export -f notice_log
export -f err_log

export -f info
export -f notice
export -f error


WAIT_JOB_ENABLE=false
JOB_NAME=""
JOB_PID=""
JOB_TEMP="/var/tmp/.start-job"
CURRENT_PIDS=""
unset CURRENT_PIDS
export -f err_exit

export JOBS_INFO_FIFO=$JOB_TEMP/$$.inf
###message format in JOBS_INFO_FIFO:
###exit_code job_name1 pid1 0
###exit_code job_name2 pid2 3
###process_id job_name1 pid1
###process_id job_name2 pid2

if [ -z $SUBJOBS_STATUS_LOG ]
then
    err_exit 74 "Parent process should export SUBJOBS_STATUS_LOG variable"
fi


        

kill_process()
{
    i=0
    local wrods
    local pid
    for ((;i<3;))  # Read the latest process id if exists, mainly handle Ctrl + C
    do
        read -t 1 job_info < $JOBS_INFO_FIFO || i=`expr $i + 1` # if read emtpy, then i++
        wrods=`echo $job_info|wc -w`
        if [[ "$job_info" == "process_id"*  && $wrods -eq 3 ]]
        then
        pid=`echo "$job_info"|cut -d ' ' -f 3`
        CURRENT_PIDS=(${CURRENT_PIDS[@]} $pid)  #append pid
        fi
     done
    
    if [ ${#CURRENT_PIDS[@]} -ne 0 ]
    then
        
        kill -9 ${CURRENT_PIDS[@]} || true
        unset CURRENT_PIDS
    fi
    
    if [[ $WAIT_JOB_ENABLE == "false" ]]  # Handle when wait_subjob function was not invoked
    then
        kill_jobs
    fi
}


###one group of processes only invoke this function once before start_job function
###$1: process name($0)
###$2: process id($$)
pre_jobs()
{
    info "log file: $SUBJOBS_STATUS_LOG"
    subjob_init "$1" $$

    JOB_NAME=$1
    trap "" HUP
    trap 'exit_code=$?; \
          kill_process; \
          rm -rf $JOBS_INFO_FIFO; \
          if [ $exit_code -ne 0 ]; \
          then err_log "Job $JOB_NAME is failed, exit with $exit_code. Aborting ..."; exit $exit_code; \
          else exit 0; \
          fi;' EXIT
    
    trap 'kill_process; \
          err_log "Job $JOB_NAME receive INT or TERM signal. Aborting ..."; exit 74' INT TERM
    
    mkdir -p $JOB_TEMP
    rm -rf $JOBS_INFO_FIFO
    mkfifo -m 600 $JOBS_INFO_FIFO
    exec 6<> $JOBS_INFO_FIFO  #make this fifo not block when writing
}


###$1: process id($$)
remove_pid()
{ 
    local len
    len=${#CURRENT_PIDS[@]}
    
    for i in ${!CURRENT_PIDS[*]}
    do
        if [ -z ${CURRENT_PIDS[$i]} ]
        then
            continue
        fi
        
        if [[ ${CURRENT_PIDS[$i]} == $1 ]]
        then
            unset CURRENT_PIDS[$i] #remove pid
            break
        fi
    done
}


remove_invalid_pid()
{ 
    for i in ${!CURRENT_PIDS[*]}
    do
        if [ -z ${CURRENT_PIDS[$i]} ]
        then
            continue
        fi
        
        if [ ! -e /proc/${CURRENT_PIDS[$i]} ]
        then
            if [ -z $ret ]
            then
                unset CURRENT_PIDS[$i] #remove pid
            fi
        fi
        
    done
}


#TODO: when subjob was killed by -9, this function could not handle (zhuweibo)
wait_subjob()
{
    local exit_pids=""
    local retry_times=0  # Handle when ${#CURRENT_PIDS[@]} is 0, retry read JOBS_INFO_FIFO, double check if start new process
    local wrods
    
    WAIT_JOB_ENABLE=true
    while true
    do
        read -t 1 job_info < $JOBS_INFO_FIFO || true
        wrods=`echo $job_info|wc -w`
        if [[ "$job_info" == "process_id"*  && $wrods -eq 3 ]]
        then
            retry_times=0
            local pid
            pid=`echo "$job_info"|cut -d ' ' -f 3`
            CURRENT_PIDS=(${CURRENT_PIDS[@]} $pid)  #append pid
        elif [[ "$job_info" == "exit_code"* && $wrods -eq 4 ]]
        then
            local job_name
            local job_pid
            local exit_code
            
            job_name=`echo "$job_info"|cut -d ' ' -f 2`
            job_pid=`echo "$job_info"|cut -d ' ' -f 3`
            exit_code=`echo "$job_info"|cut -d ' ' -f 4`
            
            remove_pid $job_pid
            if [ $exit_code -ne 0 ] 
            then
                err_log "Job $job_name is failed, exit with $exit_code. Aborting ..."
                exit 74
            else
                : #subjog success
            fi
        elif [ -z "$job_info" ]
        then
            remove_invalid_pid
            
            len=${#CURRENT_PIDS[@]}
            
            if [ $len -eq 0 ]
            then
                retry_times=`expr $retry_times + 1`
                if [ $retry_times -eq 3 ]
                then
                    notice_log "All jobs are successful"
                    break
                fi
            fi
        else
            ###TODO: if format is wrong, maybe some sub-process will not killed (zhuweibo)
            err_log "$JOBS_INFO_FIFO format is wrong"
            exit 74
        fi
    done
}


###$1: process name($0)
###$2: process id($$)
subjob_init()
{
    set -e;
    JOB_NAME=$1
    JOB_PID=$2
    trap 'exit_code=$?;echo "exit_code $JOB_NAME $JOB_PID $exit_code" > $JOBS_INFO_FIFO;exit $exit_code' EXIT
    echo "process_id $JOB_NAME $JOB_PID" > $JOBS_INFO_FIFO
}


excute_cmd()
{ 
    local start
    local now
    local time_diff
    
    subjob_init "$1" $$
    info_log "Start job $1, log file is $2"
    
    start=$(date "+%s")
    set -x
    source "$1" >& "$2"
    set +x
    
    now=$(date "+%s")
    time_diff=$((now-start))

    notice_log "Job \"$1\" is successful in \"${time_diff}s\""    
}


###$1: job bin
###$2: log file
start_job()
{
    if [ -z $2 ]
    then
        err_log "Could not start job $1 without log file setting"
        exit 74
    fi
    
    bash -c "excute_cmd \"$1\" \"$2\"" &
}


output_subjobs_status()
{ 
    excute_cmd_with_root "true > $SUBJOBS_STATUS_LOG"
    tail -f  $SUBJOBS_STATUS_LOG &
}

    
export -f excute_cmd
export -f subjob_init
export -f start_job

