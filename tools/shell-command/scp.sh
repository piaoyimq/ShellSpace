#! /usr/bin/expect -f 

set ip [lindex $argv 0]

spawn scp root@$ip:/md/loggd_persistent.log* .

expect "*password:" 

send "root\r"

expect eof 

