#!/bin/bash

#find . -type f -name $1 -print -exec vim {} \;
file_list=$(find . -type f -name $1);
array=($file_list)
length=${#array[@]}
if [ $length -eq 0 ]
then
    echo "No this file"
else
    if [ $length -eq 1 ]
    then
        vim ${array[0]}
        echo ${array[0]}
    else
        for ((i=0; i<$length; i++))
        do
            echo -e "\033[31m$i\033[0m" : ${array[$i]}
        done
        echo -en "\033[32mInput file number: \033[0m"
        read variable
#        if expr $variable + 0  &>/dev/null && [ $variable -ge 0 ] && [ $variable -lt $length ]
        if grep '^[[:digit:]]*$' <<< $variable && [ $variable -ge 0 ] && [ $variable -lt $length ]
        then
            vim ${array[$variable]}
            echo ${array[$variable]}
        else
            echo "No this file: ${array[$variable]}"
        fi
    fi    
fi
