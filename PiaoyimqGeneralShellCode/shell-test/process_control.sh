#!/bin/bash

PROCESS_NAME="msgdbgate"
LOG_FILE="run.log"
PID_FILE="$PROCESS_NAME.pid"

BASE_DIR=""
RUN_DIR=""
LIB_DIR=""


function timeStamp(){
    date +'%Y/%m/%d %H:%M:%S'
}

function logMessage(){
    echo $(timeStamp) $@    
    echo $(timeStamp) $@>>$RUN_DIR/$LOG_FILE
}


function setEnv(){
  if [ -z "$BASE_DIR" ] ; then    
      PRG="$0"
    while [ -h "$PRG" ] ; do
        ls=`ls -ld "$PRG"`
        link=`expr "$ls" : '.*-> \(.*\)$'`
        if expr "$link" : '/.*' > /dev/null; then
          PRG="$link"
        else
          PRG="`dirname "$PRG"`/$link"
        fi
      done
      BASE_DIR=`dirname "$PRG"`/..
      BASE_DIR=`cd "$BASE_DIR" && pwd`
   fi
   RUN_DIR=$BASE_DIR/bin/run
   BIN_DIR=$BASE_DIR/bin
   LIB_DIR=$BASE_DIR/lib
   mkdir -p  $RUN_DIR    
}


function excuteCmdAndreportLog(){
    `eval $@`    
    logMessage $@
}


function running(){
    if [ -f "$RUN_DIR/$PID_FILE" ]; then
        pid=$(cat "$RUN_DIR/$PID_FILE")
        #logMessage "check :  pid=$pid "
        process=`ps aux | grep " $pid " | grep -v grep`;
                #logMessage "result: $process"
        if [ "$process" == "" ]; then
                return 1;
        else
            return 0;
        fi
    else
        return 1
    fi
}


function start_server(){    
        if running ;then
        logMessage "$PROCESS_NAME is running "
        exit 1
     fi
        logMessage "----------------------------------> start_server    $PROCESS_NAME "                
        logMessage "nohup $BIN_DIR/$PROCESS_NAME  2>&1 1>&/dev/null  &" 
    export LD_LIBRARY_PATH=../lib:/usr/local/mysql/lib/:$LD_LIBRARY_PATH
        chmod a+x $BIN_DIR/$PROCESS_NAME
    nohup $BIN_DIR/$PROCESS_NAME  2>&1 1>&/dev/null  &
    echo $! >$RUN_DIR/$PID_FILE
    excuteCmdAndreportLog "chmod 755 $RUN_DIR/$PID_FILE"
    sleep 2
    if running ;then
                logMessage "$PROCESS_NAME is running    "
                exit 1
        fi
    logMessage "$PROCESS_NAME start failed !"
    #tail -f $LOG_DIR/$LOG_FILE
}

function stop_server(){
    if ! running;then
        logMessage "$PROCESS_NAME was not running"
        exit 1
    fi
    count=0
    pid=$( cat $RUN_DIR/$PID_FILE)
    while running; do
        let count=$count+1
        logMessage "stopping $PROCESS_NAME $count times !!!"
        if [ $count -gt 5 ] ;then
            excuteCmdAndreportLog "kill -9 $pid"
        else
            sleep 1
            excuteCmdAndreportLog "kill  $pid"
        fi
        sleep 2
    done
    logMessage "-----------> stop $PROCESS_NAME successfully <------------"
    excuteCmdAndreportLog "rm $RUN_DIR/$PID_FILE"
}

function monit_server(){
        if running ;then                
                exit 1
        fi    
        chmod a+x $BIN_DIR/$PROCESS_NAME
        nohup $BIN_DIR/$PROCESS_NAME  2>&1 1>&/dev/null  &
        echo $! >$RUN_DIR/$PID_FILE
        chmod 755 $RUN_DIR/$PID_FILE        
}

function status(){
    if running; then
       logMessage "$PROCESS_NAME is running.";
       exit 0;
    else
       logMessage "$PROCESS_NAME was stopped.";
       exit 1;
    fi
}


SERVER_NAME=$PROCESS_NAME
function help() {
    echo "------------------------------------------------------------------------------"
    echo "Usage: server.sh {start|status|stop|restart|logback}" >&2
    echo "       start:             start the $SERVER_NAME server"
    echo "       stop:              stop the $SERVER_NAME server"
    echo "       restart:           restart the $SERVER_NAME server"
    echo "       logback:           reload logback config file"
    echo "       status:            get $SERVER_NAME current status,running or stopped."
    echo "-----------------------------------------------------------------------------"
    
}

function getOpts(){    
    command=$1    
    shift 1
    case $command in
        start)
            start_server $@;
            ;;    
        stop)
            stop_server $@;
            ;;
        logback)
            reload_logback_config $@;
            ;;
        status)
            status $@;
            ;; 
        monit)
        monit_server $@;
        ;;
        restart)
            $0 stop $@
            $0 start $@
          ;;
        help)
            help;
            ;;
        *)
            help;
            exit 1;
            ;;
    esac
}

function main(){
    logMessage "-------->  begin <-------------"
    setEnv $@
    logMessage "BASE_DIR:$BASE_DIR"    
    getOpts $@
    logMessage "-------->  end "

}

main
