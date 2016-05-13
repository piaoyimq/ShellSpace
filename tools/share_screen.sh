#!/bin/sh

#######################################################################################
# the script is used to create shared session cross differnt linux user.
# note !!! the user you share session with has all your permission. 
# so please kill the session once the sharing end.
#######################################################################################

FULL_NAME=$0
EXE_PATH=`dirname $FULL_NAME`
EXE_NAME=`basename $FULL_NAME`
#TMUX=$EXE_PATH/tmux

TMUX=/home/eguoyzh/local/bin/tmux
TMUX_CFG=/home/eguoyzh/.tmux.conf
TMUX_DIR=/tmp/${USER}_tmux_share


function usage(){
    echo "Usage:"
    echo "    $EXE_NAME [-c <session>] | [-l] | [-a <session> <user>] | [-k <session>]"
    echo "    -c: create session"
    echo "    -a: attach to session shared by <user>"
    echo "    -l: list session"
    echo "    -k: kill session"
}

function checkSession(){
    if [ "$1" = "" ]; then
        echo "please input session name"
        exit
    fi
}

if [ $# -lt 1 ]; then
    usage
    exit
fi

SESSION=$2

if [ "$1" = "-c" ]; then
    checkSession $SESSION
    exist=`$TMUX -S $TMUX_DIR has-session -t $SESSION 2>&1`
    if [ "$exist" != "" ]; then
        if [ ! -f ~/.tmux.conf ]; then
            cp $TMUX_CFG ~/
        fi
        $TMUX -S $TMUX_DIR new -s $SESSION -d
        chmod 777 $TMUX_DIR
    else
        echo "the session $SESSION exists already, please use other name"
    fi
elif [ "$1" = "-l" ]; then
    $TMUX -S $TMUX_DIR list-session
elif [ "$1" = "-k" ]; then
    checkSession $SESSION
    $TMUX  -S $TMUX_DIR kill-session -t $SESSION 
elif [ "$1" = "-a" ]; then
    checkSession $SESSION
    if [ "$3" = "" ]; then
        echo "please input linux user name"
        exit
    fi
    $TMUX -S /tmp/${3}_tmux_share attach -t $SESSION
else
    usage
fi

