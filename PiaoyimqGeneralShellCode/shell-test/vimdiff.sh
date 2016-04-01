#!/bin/bash

#find . -type f -name $1 -print -exec vim {} \;
file_list=$(find . -type f -name $2);
array=($file_list)
length=${#array[@]}
base_dir="/repo/ezhweib/epg-"

if [ $length -eq 0 ]
then
    echo "No this file"
else
    if [ $length -eq 1 ]
    then
        if [ -f "$base_dir$1/${array[0]:2}" ]
        then
            echo "vimdiff ${array[0]} $base_dir$1/${array[0]:2}"
            vimdiff ${array[0]} $base_dir$1/${array[0]:2}
        else
            echo "No this file in $base_dir$1/"
        fi
    else
        for ((i=0; i<$length; i++))
        do
            echo -e "\033[31m$i\033[0m" : ${array[$i]}
        done
        echo -en "\033[32mInput file number: \033[0m"
        read variable
        if expr $variable + 0 &>/dev/null && [ $variable -ge 0 ] && [ $variable -lt $length ]
        then
            if [ -f "$base_dir$1/${array[$variable]:2}" ]
            then
                echo "vimdiff ${array[$variable]} $base_dir$1/${array[$variable]:2}"
                vimdiff ${array[$variable]} $base_dir$1/${array[$variable]:2}
            else
                echo "No this file in $base_dir$1/"
            fi
        else
            echo "No this file"
        fi
    fi    
fi
