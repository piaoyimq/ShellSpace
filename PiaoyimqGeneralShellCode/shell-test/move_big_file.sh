#!/bin/bash
#move the file which exceed 100 bytes to /tmp directory.
#Keep this shell file locate the $FILE in the same directory.
#

for FILE in `ls /usr/local/test`
do
    if [ -f $FILE ] ; then
        if [ `ls -l  $FILE | awk '{print $5}'` -gt 100 ];then
            mv $FILE  /tmp/
    	    echo "move $FILE to /tmp"
        fi
    fi
done
