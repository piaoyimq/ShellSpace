#! /usr/bin/expect -f 

set ip [lindex $argv 0]

spawn scp erv@$ip:/md/loggd_persistent.log* .

expect "*password:" 

send "ggsn\r"
#expect eof 

#exec sh -c {gunzip *.gz}

spawn scp erv@$ip:/md/services/epg/fm/alarm-history .
expect "*password:"
send "ggsn\r"
expect eof

#exec sh -c {
#if [ -f *.gz ]
#then
#    gunzip *.gz
#fi
#}
