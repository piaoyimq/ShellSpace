#!/bin/bash
#This shell only could be ran under currently, use './env-setup.sh'
#


BASE_PATH=$(cd $(cd "$(dirname "$0")"; pwd)/..; pwd)
BIN_PATH=$HOME/bin

#set -x

##############git config
hist_command="[alias]
	hist = log --graph --pretty=format:'%Cred%h%Creset %s -%C(yellow)%d%Creset% Cgreen[%an]%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

git_config=("hist" "test")
length=${#git_config[@]}

for ((i=0; i<$length; i++))
do
    result=$(grep "${git_config[$i]}" .git/config) 
if [ -z "$result" ]
then
    #echo -e "\033[31m$i\033[0m" : ${git_config[$i]} #debug
   case ${git_config[$i]} in
       hist )
	    echo "$hist_command" >> .git/config ;;

       test )
          echo #"test" ;;
   esac
fi

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
