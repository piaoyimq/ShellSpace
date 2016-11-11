#!/bin/bash 
length=$#
usage() {
        echo "Usage: backup.sh <options>
        -l: list backup fils
        -d: delete backup fils"
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
        find . -type f -name "*~";;
        d ):
        find . -type f -name "*~" |xargs -t -i rm -rf {};;
        * ):
        usage; exit 0 ;;
    esac
done



