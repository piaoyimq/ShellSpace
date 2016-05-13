#!/bin/bash
set -x
sed -i "s/$2/$3/g" `grep "$2" $1 -rl`
