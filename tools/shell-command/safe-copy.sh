#!/bin/bash
#if not exist, copy it.  
#If exist, check if it is the same, 
#if same not copy, else copy it, and prompt do you want to override
#$1 and $2 must be a filename

#set -x

safe_copy()
{
   if [[ ! -f $2 && ! -d $2 ]] 
   then
       cp $1 $2
   else
        if [ ! -f $2 ]
        then 
            echo "$2  must be fileanme."
            exit
        fi
       ret=`diff $1 $2`
       if [ -n "$ret" ]
       then
           cp $2 $2-old
           cp -i $1 $2
       fi
   fi
}


if [ ! -f $1 ]
then 
    echo "$1  must be fileanme."
    exit
else
    safe_copy $1 $2
fi
