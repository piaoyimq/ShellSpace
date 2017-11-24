#!/bin/expect 


set ip [lindex $argv 0]
spawn ssh erv@$ip

expect {
 "*password:" {send "ggsn\r" }
 "*(yes/no)?" { send "yes\r" exp_continue}}
interact

#exec ${SHELL-tcsh}

