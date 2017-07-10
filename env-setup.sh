#!/bin/bash
#This shell only could be ran under currently, use './env-setup.sh'
#


WS_ROOT=$(pwd)
BIN_PATH=$HOME/bin

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


cpp_env()
{
    export AUTOMOCK_GCC_ROOT="/compilers/gcc4.8.5-rhel6.6-binutils2.24.gold"
    export AUTOMOCK_GCC_PREFIX="/compilers/gcc4.8.5-rhel6.6-binutils2.24.gold/bin/"
}


##############git config
git_config()
{
    $BASE_PATH/ShellSpace/tools/shell-command/safe-copy.sh  $BASE_PATH/ShellSpace/tools/git/gitconfig ~/.gitconfig
}

#shell

mk_symbolink()
{
    
    if [ ! -d $BIN_PATH ] 
    then
        mkdir $BIN_PATH 
    fi
    
    cp -fLrs $BASE_PATH/ShellSpace/tools/shell-command/* $BIN_PATH
}

########bash Initial
bash_init()
{
    $BASE_PATH/ShellSpace/tools/shell-command/safe-copy.sh  $BASE_PATH/ShellSpace/tools/bash/bash-init.sh ~/.bash-init.sh
    $BASE_PATH/ShellSpace/tools/shell-command/safe-copy.sh  $BASE_PATH/ShellSpace/tools/bash/bash-aliases ~/.bash-aliases
    add_string_in_file bash-init.sh ~/.bashrc "source ~/.bash-init.sh"
}





main ()
{

    [ -z "$BASE_PATH" ] || err_exit 73 "Please exit your current git workspace before setting up new!" 
    export BASE_PATH=$(cd $(cd "$(dirname "$0")"; pwd)/..; pwd)
    export WS_ROOT
    echo "Initial workspace..."

    git_config
    mk_symbolink
    bash_init
    cpp_env
    PATH=$BASE_PATH/CppSpace/tools/bin:$BIN_PATH:$BIN_PATH/compile:$PATH 
    export PATH=$(awk -F: '{for(i=1;i<=NF;i++){if(!($i in a)){a[$i];printf s$i;s=":"}}}'<<<$PATH) # Remove duplicates

    exec bash # Take over this shell process
    #exec /bin/tcsh # Take over this shell process
    #exec tcsh # Take over this shell process
    #exec zsh
}

main "$@"
