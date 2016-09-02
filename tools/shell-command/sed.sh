#!/bin/bash

if [ $# != 3 ]
then
    echo "Usage: sed.sh . old new"
        exit 65
fi


set -x
sed -i "s/$2/$3/g" `grep "$2" $1 -rl`
