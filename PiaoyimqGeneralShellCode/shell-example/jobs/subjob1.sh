#!/bin/bash -e
set -x


subjob_init $0 $$


echo "____$0, pid=$$, ppid=$PPID"
while :; do       #: equal true.
    sleep 3
    exit 0
done