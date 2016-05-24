#!/bin/bash
#This shell only could be ran under currently, use './env-setup.sh'
#


BASE_PATH=$(cd $(cd "$(dirname "$0")"; pwd)/..; pwd)
BIN_PATH=$HOME/bin

#set -x

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
              echo #"test" ;;
       esac
done
 
git config --global color.status auto
git config --global color.add auto

############git mergetool vimdiff config:http://www.cnblogs.com/yaozhongxiao/p/3869862.html

#shell

if [ ! -d $BIN_PATH ] 
then
    mkdir $BIN_PATH 
fi

cd $BIN_PATH
ln -fs $BASE_PATH/ShellSpace/tools/shell-command/vim.sh vim.sh 
ln -fs $BASE_PATH/ShellSpace/tools/shell-command/vimdiff.sh vimdiff.sh 
ln -fs $BASE_PATH/ShellSpace/tools/shell-command/du.sh du.sh 
ln -fs $BASE_PATH/ShellSpace/tools/shell-command/sed.sh sed.sh
path_content="export PATH=$BASE_PATH/CppSpace/output/Linux_x86/bin/:\$PATH"

add_string_in_file "CppSpace/output" "$HOME/.bashrc" "$path_content"
bash $HOME/.bashrc
