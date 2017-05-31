#!/bin/bash
#This shell only could be ran under currently, use './env-setup.sh'
#


WS_ROOT=$(pwd)
BIN_PATH=$HOME/bin

#set -x
# Exit with error, $1 exit code (/usr/include/sysexits.h), $2 text output
err_exit()
{
	echo -e "Error: $2\nAborting..." >&2
	exit $1
}

add_string_in_file()
{
#$1 is keyword
#$2 is filename
#$3 is added string 
    result=$(grep "$1" $2) 
    if [ -z "$result" ]
    then
	    echo "$3" >> $2
    fi

}

##############git config
git_config()
{
   if [ ! -f ~/.gitconfig ] 
   then
       cp $BASE_PATH/ShellSpace/tools/git/.gitconfig ~/
   fi
}

#shell

mk_symbolink()
{
    
    if [ ! -d $BIN_PATH ] 
    then
        mkdir $BIN_PATH 
    fi
    
    cd $BIN_PATH
    ln -snf $BASE_PATH/ShellSpace/tools/shell-command/vim.sh vim.sh 
    ln -snf $BASE_PATH/ShellSpace/tools/shell-command/vimdiff.sh vimdiff.sh 
    ln -snf $BASE_PATH/ShellSpace/tools/shell-command/du.sh du.sh 
    ln -snf $BASE_PATH/ShellSpace/tools/shell-command/sed.sh sed.sh
    ln -snf $BASE_PATH/ShellSpace/tools/shell-command/backup.sh backup.sh
    ln -snf $BASE_PATH/ShellSpace/tools/shell-command/scp.sh scp.sh
    ln -snf $BASE_PATH/ShellSpace/tools/shell-command/cat.sh cat.sh
    PATH=$BASE_PATH/CppSpace/output/Linux_x86/bin/:$PATH
    cd $WS_ROOT
}


main ()
{

    [ -z "$BASE_PATH" ] || err_exit 73 "Please exit your current git workspace before setting up new!" 
    export BASE_PATH=$(cd $(cd "$(dirname "$0")"; pwd)/..; pwd)
    export WS_ROOT
    echo "Initial workspace..."

    git_config
    mk_symbolink
    PATH=$BASE_PATH/CppSpace/tools/bin:$BIN_PATH/compile:$PATH 
    export PATH=$(awk -F: '{for(i=1;i<=NF;i++){if(!($i in a)){a[$i];printf s$i;s=":"}}}'<<<$PATH) # Remove duplicates

    #exec ${SHELL-tcsh} # Take over this shell process
    exec /bin/tcsh # Take over this shell process
    #exec /bin/bash # Take over this shell process
}

main "$@"
