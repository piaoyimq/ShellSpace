#!/bin/bash
set -x

#using select in the menu

temp='mktemp -t temp.XXXXXX'
temp2='mktemp -t temp2.XXXXXX'

function diskspace {
    df -h > $temp
    kdialog --textbox $temp 1000 10
}

function whoseon {
    who > $temp
    kdialog --textbox $temp 500 10
}

function memusage {
    cat /proc/meminfo > $temp
    kdialog --textbox $temp 300 500
}

while [ 1 ]
do
    kdialog --menu "Sys Admin Menu" "1" "Display diskspace" "2" "Display users" "3" "Display memory usage" "0" "Exit" > '$temp2'

    if [ $? -eq 0 ]
    then
        break
    fi

    selection='cat $temp2'

    case $selection in
        1)
            diskspace
            break
            ;;
        2)
            users
            break
            ;;
        3)
            memusage
            break
            ;;
        0)
            break
            ;;
        *)
            kdialog --msgbox "Sorry, wrong selection."
    esac
done