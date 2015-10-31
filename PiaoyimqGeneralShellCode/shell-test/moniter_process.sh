#!/bin/sh
echo "`date`"
echo "Start $0---------"
echo ""
#每十秒监视一下
sec=10
#取得指定进程名为mainAPP，内存的使用率，进程运行状态，进程名称
eval $(ps | grep "mainApp" | grep -v grep | awk  {'printf("memInfo=%s;myStatus=%s;pName=%s",$3,$4,$5)'})
echo $pName $myStatus $memInfo
testPrg=""
while [ -n "$pName"  -a "$myStatus" != "Z" ]
do
        echo "----------`date`---------------------"
        echo $pName $myStatus $memInfo
        sleep $sec
        ####You must initialize them again!!!!!
        pName=""
        myStatus=""
        memInfo=""
        eval $(ps | grep "mainApp" | grep -v grep | awk  {'printf("memInfo=%s;myStatus=%s;pName=%s",$3,$4,$5)'})
        testPrg=`ps | grep "MyTester" | grep -v grep | awk '{print $0}'`
        if [ -z "$testPrg" ]; then
                break
        fi
        ##注意一定要再次初始化为空
        testPrg=""
done
echo "End $0---($pName,$myStatus,$testPrg)-------------------"
if [ -z "$pName" ]; then
                ###发现测被测试程序异常退出后，停止测试程序
        killall MyTester
        echo "stop TestProgram MyTester"
fi
echo "`date`"
echo "---------------Current Status------------------"
ps | grep -E "mainApp|SubApp"  | grep -v grep
echo ""
