#!/bin/bash

if [ $# != 3 ]
then
    echo "Usage: sed.sh . old new"
        exit 65
fi


set -x
grep -w "$2" $1 -r
set +x
echo -en "\033[32mDo you want to replace?(y/n): \033[0m"
read variable
if [ $variable == 'y' ]
then
sed -i "s/$2/$3/g" `grep -w "$2" $1 -rl`
fi
