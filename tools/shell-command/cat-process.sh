#!/bin/bash
#set -x

length=$#
usage() {
    echo "Usage: cat-process.sh <process-name>>
    cat-process.sh gtpcd
    cat-process.sh fmd"
    exit 65
}

if [ $length != 1 ]
then
    usage
fi

process_list=$(cat.sh loggd_persistent.log*|grep -oP " $1\[\d+:*\d+\]"|sort -u)
#echo $process_list
array=($process_list)
length=${#array[@]}

if [ $length -eq 0 ]
then
    echo "No this process $1"
else
    if [ $length -eq 1 ]
    then
        cat.sh loggd_persistent.log* | grep -P " $1\[\d+:*\d+\]" | sort -k 7 -n
    else
        for ((i=0; i<$length; i++))
        do
            echo -e "\033[31m$i\033[0m" : ${array[$i]}
        done
        echo -en "\033[32mInput sequence number: \033[0m"
        read variable
        if grep '^[[:digit:]]*$' <<< $variable &>/dev/null && [ $variable -ge 0 ] && [ $variable -lt $length ]
        then
            echo ${array[$variable]}
            result=$(echo  ${array[$variable]}| sed -e "s/\[/\\\[/g" -e "s/\]/\\\]/g")
            #echo "____result="$result
             
            cat.sh loggd_persistent.log* | grep -P "$result" | sort -k 7 -n
        else
            echo "No this process: ${array[$variable]}"
        fi
    fi    
fi
