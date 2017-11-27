#!/bin/expect 


set ip [lindex $argv 0]
spawn ssh erv@$ip

expect {
 "*(yes/no)?" { send "yes\r"; exp_continue}
 "*password:" {send "ggsn\r" }
 }
interact

#exec ${SHELL-tcsh}

