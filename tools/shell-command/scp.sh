#!/bin/bash
#set -x

PWD=`pwd`
basedirname=`basename $PWD`
dst_dir=`pwd`
    echo -n ""
if [ "$basedirname" == $1 ]
then
    echo -n ""
    echo "parent is $1"
else
#    echo "parent is not $1"

    if [ ! -d $1 ]
    then
        mkdir $1
    else
        echo -n ""
#        echo "current is $1"
    fi
    dst_dir=$dst_dir/$1
#    echo "new path: $dst_dir"
fi

copy()
{
/usr/bin/expect <<-EOF

spawn scp erv@$1:/md/loggd_* $2

expect "*password:" 

send "ggsn\r"
expect eof 


spawn scp erv@$1:/md/services/epg/fm/alarm-history $2
expect "*password:"
send "ggsn\r"
expect eof

EOF
}


copy $1 $dst_dir
cd $dst_dir
#exec ${SHELL-tcsh}
