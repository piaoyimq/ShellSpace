#!/bin/bash

#set -x


for data in $@
do
    #echo ${data}
if [[ ${data} == *.gz ]]
then 
    #echo "End with *.gz"
    zcat ${data}
else
    #echo "not end with *.gz"
    cat ${data}
fi
done
