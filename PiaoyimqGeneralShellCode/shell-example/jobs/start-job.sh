#!/bin/bash -e
set -x

unalias -a

source /home/azhweib/repo/em-360-2/common/bash/basic-function.sh


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



        

kill_process()
{
    if [ ${#CURRENT_PIDS[@]} -ne 0 ]
    then
        read -t 1 job_info < $JOBS_INFO_FIFO # Read the latest process id if exists
        local wrods=`echo $job_info|wc -w`
        if [[ "$job_info" == "process_id"*  && $wrods -eq 3 ]]
        then
            local pid=`echo "$job_info"|cut -d ' ' -f 3`
            CURRENT_PIDS=(${CURRENT_PIDS[@]} $pid)  #append pid
        fi
        kill -9 ${CURRENT_PIDS[@]}
        unset CURRENT_PIDS
    fi
    
    if [[ $WAIT_JOB_ENABLE == "false" ]]  # Handle when wait_subjob function was not invoked
    then
        kill_jobs
    fi
    
    
}


###$1: process name($0)
pre_jobs()
{ 
    JOB_NAME=$1
    trap "" HUP
    trap 'exit_code=$?; \
          kill_process; \
          rm -rf $JOBS_INFO_FIFO; \
          if [ $exit_code -ne 0 ]; \
          then err_exit $exit_code "job: $JOB_NAME exit with $exit_code"; \
          else exit 0; \
          fi;' EXIT
    
    trap 'kill_process; \
          err_exit 74 "job: $JOB_NAME receive INT or TERM signal"' INT TERM
    
    mkdir -p $JOB_TEMP
    rm -rf $JOBS_INFO_FIFO
    mkfifo -m 600 $JOBS_INFO_FIFO
    exec 6<> $JOBS_INFO_FIFO  #make this fifo not block when writing
}


###$1: process id($$)
remove_pid()
{ 
    echo "________before remove, current pid=_\"${CURRENT_PIDS[@]}\"_"
    local len=${#CURRENT_PIDS[@]}
    len=`expr $len + 1` #((len++)) #TODO: why +1 (why had empty string in array)
    for ((i=0;i<$len;i++))
    do
        if [[ ${CURRENT_PIDS[$i]} == $1 ]]
        then
            unset CURRENT_PIDS[$i] #remove pid
            break
        fi
    done
    
}


#TODO: when subjob was killed by -9, this function could not handle (zhuweibo)
wait_subjob()
{
    local exit_pids=""
    local retry_times=0  # Handle when ${#CURRENT_PIDS[@]} is 0, retry read JOBS_INFO_FIFO, double check if start new process
    WAIT_JOB_ENABLE=true
    while true
    do
        echo "____read:"
        if [ $retry_times -eq 0 ]
        then
            read job_info < $JOBS_INFO_FIFO
        else
            read -t 2 job_info < $JOBS_INFO_FIFO || true
        fi
        
        local wrods=`echo $job_info|wc -w`
        if [[ "$job_info" == "process_id"*  && $wrods -eq 3 ]]
        then
        
            if [ $retry_times -gt 0 ]
            then
                #retry_times=`expr $retry_times - 1`
                retry_times=0
            fi
            
            local pid=`echo "$job_info"|cut -d ' ' -f 3`
            CURRENT_PIDS=(${CURRENT_PIDS[@]} $pid)  #append pid
            echo "________after append $pid, current pid=${CURRENT_PIDS[@]}"
        elif [[ "$job_info" == "exit_code"* && $wrods -eq 4 ]]
        then
            local job_name=`echo "$job_info"|cut -d ' ' -f 2`
            local job_pid=`echo "$job_info"|cut -d ' ' -f 3`
            local exit_code=`echo "$job_info"|cut -d ' ' -f 4`
            
            if [ $exit_code -ne 0 ] 
            then
                remove_pid $job_pid
                echo "________after remove1 $job_pid, current pid=${CURRENT_PIDS[@]}"
                err_exit $exit_code "$job_name exit with $exit_code"  
            else
                notice "$job_name excuted successfully"
                remove_pid $job_pid
                echo "________after remove2 $job_pid, current pid=${CURRENT_PIDS[@]}"
                len=${#CURRENT_PIDS[@]}
                
                if [ $len -eq 0 ]
                then
                    retry_times=`expr $retry_times + 1`
                    if [ $retry_times -eq 3 ]
                    then
                        notice "All jobs excuted successfully"
                        break
                    fi
                fi
            fi
        elif [ -z "$job_info" ]
        then
            retry_times=`expr $retry_times + 1`
            len=${#CURRENT_PIDS[@]}
            
            if [[ $retry_times -eq 3 && $len -eq 0 ]]
            then
                notice "All jobs excuted successfully"
                break
            fi
        else
            ###TODO: if format is wrong, maybe some sub-process will not killed (zhuweibo)
            err_exit 74 "$JOBS_INFO_FIFO format is wrong"         
        fi
        echo "____current_pids=${CURRENT_PIDS[@]}"
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


start_job()
{
    $1&
}


export -f subjob_init