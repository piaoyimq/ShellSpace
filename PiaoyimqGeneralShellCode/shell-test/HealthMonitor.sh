#!/bin/sh
##################################
#Author : 154353294@qq.com
#Date   : 2015-10-1
#Funtion: Monitor MainProcess's status,
#         IF the status of MainProcess process is Z ,then reboot system;
#         IF the MainProcess process exit abnormally,then reboot application;
#         IF the CPU usage of MainProcess process above 95% duration 3mins, then reboot applicaion.
#         The log of shell output to current directory named HealthMonitor_YYYYMMDDHHMMSS.log.
##################################
var=$0
LOGFILE=${var%%.sh}_`date "+%Y%m%d%H%M%S"`.log
echo "`date "+%Y-%m-%d %H:%M:%S"`"#"Start " > $LOGFILE
sec=3
t_start=0
t_perCurrent=0
t_current=0
total=0
MaxTimes=60 ##3*60=180s
#获取主进程的PID,内存使用率，CPU使用率，以及名称。
eval $(top -n 1| grep "MainProcess" | grep -v grep | awk  {'printf("mainPID=%s;myStatus=%s;memInfo=%s;cpuRatio=%s;pName=%s\n",$1,$4,$5,$7,$8)'})
echo `date "+%Y-%m-%d %H:%M:%S"`"#"$mainPID $myStatus  ${memInfo%%m}   ${cpuRatio%%%} $pName >> $LOGFILE

while [ true ]
do
while [  -n "$pName" ] ##MainProcess exist
    do
#       echo "`date "+%Y-%m-%d %H:%M:%S"` ####" >> $LOGFILE
        sleep $sec
        ####You must initialize them again!!!!!
        mainPID=""
        myStatus=""
        memInfo=""
        cpuRatio=""
        pName=""
        eval $(top -n 1| grep "MainProcess" | grep -v grep | awk  {'printf("mainPID=%s;myStatus=%s;memInfo=%s;cpuRatio=%s;pName=%s\n",$1,$4,$5,$7,$8)'})
            if [  ${cpuRatio%%%} -gt 95 ]; then
            #3分钟内持续负载都在95%以上的处理
#           echo  `date "+%Y-%m-%d %H:%M:%S"`"#"Cpu Usage  High: $mainPID $myStatus  ${memInfo%%m}   ${cpuRatio%%%} $pName >> $LOGFILE
            if [ $total -eq 0 ]; then
               t_start=$(date +%s) ### set first time to Seconds
               total=$(($total+1))
               t_perCurrent=$t_start
            else 
                    t_current=$(date +%s) ### set current time to Seconds

               if [ $total -ge $MaxTimes ]; then ## 3 Mins
                break;
                           fi


                           if [ $(($t_current-$t_perCurrent)) -ge 4 ]; then ##not continue
                                t_start=$(date +%s) ### set current time to Seconds
                total=1
                t_perCurrent=$t_start
               else
                        total=$(($total+1))
                    t_perCurrent=$(date +%s) ### set current time to Seconds
                           fi       
            fi          
    #   else
    #       echo  `date "+%Y-%m-%d %H:%M:%S"`"#"Cpu Usage Low  : $mainPID $myStatus  ${memInfo%%m}   ${cpuRatio%%%} $pName >> $LOGFILE
        fi
        if [ -z "$pName" ]; then

                break
        fi
        if [ "$myStatus" = "Z" ]; then
                break
        fi

done

if [  $total -ge $MaxTimes ]; then
    echo "`date "+%Y-%m-%d %H:%M:%S"`#Cpu usage run high duration 3 Mins!~"  >> $LOGFILE
    echo "`date "+%Y-%m-%d %H:%M:%S"`#System will reboot application~"       >> $LOGFILE
    killall SubProcess
    killall MainProcess
    #重启自启动的Shell
    /etc/init.d/mystart.sh monitor 

    t_start=0
    t_perCurrent=0
    t_current=0
    total=0

    mainPID=""
    myStatus=""
    memInfo=""
    cpuRatio=""
    pName=""
    eval $(top -n 1| grep "MainProcess" | grep -v grep | awk  {'printf("mainPID=%s;myStatus=%s;memInfo=%s;cpuRatio=%s;pName=%s\n",$1,$4,$5,$7,$8)'})
    echo `date "+%Y-%m-%d %H:%M:%S"`"#"$mainPID $myStatus  ${memInfo%%m}   ${cpuRatio%%%} $pName
    sleep 30
    continue
fi
if [ -z "$pName" ]; then
    echo "`date "+%Y-%m-%d %H:%M:%S"`#MainProcess is not exist!!"  >> $LOGFILE
    echo "`date "+%Y-%m-%d %H:%M:%S"`#System will reboot application~"       >> $LOGFILE
    killall SubProcess
    /etc/init.d/mystart.sh monitor
    mainPID=""
    myStatus=""
    memInfo=""
    cpuRatio=""
    pName=""
    eval $(top -n 1| grep "MainProcess" | grep -v grep | awk  {'printf("mainPID=%s;myStatus=%s;memInfo=%s;cpuRatio=%s;pName=%s\n",$1,$4,$5,$7,$8)'})
    echo `date "+%Y-%m-%d %H:%M:%S"`"#"$mainPID $myStatus  ${memInfo%%m}   ${cpuRatio%%%} $pName
    sleep 30
    continue
fi
if [ "$myStatus" = "Z" ]; then
    echo "`date "+%Y-%m-%d %H:%M:%S"`#MainProcess  is Z  status!!"  >> $LOGFILE
    echo "`date "+%Y-%m-%d %H:%M:%S"`#System will reboot application~"       >> $LOGFILE
    killall SubProcess
    killall MainProcess
    reboot
fi
done
echo "`date "+%Y-%m-%d %H:%M:%S"`"#"End ">> $LOGFILE
