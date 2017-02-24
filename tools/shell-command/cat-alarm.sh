#!/bin/bash
#usage:  cat alarm-history.3 3157993
#set -x
cat $1|grep -B 1 -A 9 "Fault Id: $2"
