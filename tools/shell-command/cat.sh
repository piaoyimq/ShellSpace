#!/bin/bash

if [[ $1 == *.gz ]]
then 
    echo "End with *.gz"
    zcat $1
else
    echo "not end with *.gz"
    cat $1
fi
