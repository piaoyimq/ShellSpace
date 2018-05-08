#!/bin/bash
length=$#
usage() 
{
        echo "Usage: backup.sh <options>
        -l: list untracked fils
        -d: delete untracked fils"
        exit 65
}

if [ $length != 1 ]
then
    usage
fi

while getopts "ld" flag
do
    case $flag in
        l ):
        svn status|grep '?'|awk '{print $NF}';;
        d ):
        svn status|grep '?'|awk '{print $NF}'|xargs -i -t rm -rf {};;
        * ):
        usage; exit 0 ;;
    esac
done

