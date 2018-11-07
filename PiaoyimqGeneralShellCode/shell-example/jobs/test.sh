#!/bin/bash
set -x
for ((i=0;i<10;i++))
do
    ./father.sh
    ps -ef|grep father >> test.log
    ps -ef|grep subjob >> test.log
    
done