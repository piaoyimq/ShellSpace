#!/bin/bash
#This shell only could be ran under currently, use './env-setup.sh'
#


CODE_PATH=$(pwd)
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
hist_command="[alias]
	hist = log --graph --pretty=format:'%Cred%h%Creset %s -%C(yellow)%d%Creset% Cgreen[%an]%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

git_config=("hist" "test")
length=${#git_config[@]}

for ((i=0; i<$length; i++))
do
    case ${git_config[$i]} in
           hist )
            add_string_in_file "${git_config[$i]}" ".git/config" "$hist_command";;
    
           test )
            #add_string_in_file "${git_config[$i]}" .git/config $hist_command;;
              : #do nothing
       esac
done
 
git config --global color.status auto
git config --global color.add auto

############git mergetool vimdiff config:http://www.cnblogs.com/yaozhongxiao/p/3869862.html

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
    PATH=$BASE_PATH/CppSpace/output/Linux_x86/bin/:$PATH
    cd $CODE_PATH
}


main ()
{

    [ -z "$BASE_PATH" ] || err_exit 73 "Please exit your current git workspace before setting up new!" 
    export BASE_PATH=$(cd $(cd "$(dirname "$0")"; pwd)/..; pwd)
    echo "Initial workspace..."

    mk_symbolink
    PATH=$BASE_PATH/CppSpace/tools/bin:$BIN_PATH/compile:$PATH 
    export PATH=$(awk -F: '{for(i=1;i<=NF;i++){if(!($i in a)){a[$i];printf s$i;s=":"}}}'<<<$PATH) # Remove duplicates

    exec ${SHELL-tcsh} # Take over this shell process
}

main "$@"
