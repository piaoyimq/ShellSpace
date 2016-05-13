#!/bin/bash
#This shell only could be ran under currently, use './env-setup.sh'
#


BASE_PATH=$(cd $(cd "$(dirname "$0")"; pwd)/..; pwd)
BIN_PATH=$HOME/bin
echo BASE_PATH:$BASE_PATH
#git

set -x
#echo "[alias]
grep 'hist' .git/config 
if [ $? -eq 0 ]
then
    echo "already have hist"
else
    echo "no hist"
#	hist = log --graph --pretty=format:'%Cred%h%Creset %s -%C(yellow)%d%Creset% Cgreen[%an]%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative" >> .git/config
fi

git_config=("hist" "color.status" "color.add")
length=${#git_config[@]}

for ((i=0; i<$length; i++))
do
    grep "${git_config[$i]}" .git/config 
    echo -e "\033[31m$i\033[0m" : ${git_config[$i]}
done
 
#git config --global color.status auto
#git config --global color.add auto


#shell

if [ ! -d $BIN_PATH ] 
then
    mkdir $BIN_PATH 
    cd $BIN_PATH
    ln -s $BASE_PATH/ShellSpace/tools/shell-command/vim.sh vim.sh 
    ln -s $BASE_PATH/ShellSpace/tools/shell-command/vimdiff.sh vimdiff.sh 
    ln -s $BASE_PATH/ShellSpace/tools/shell-command/du.sh du.sh 
    ln -s $BASE_PATH/ShellSpace/tools/shell-command/sed.sh sed.sh
else
    cd $BIN_PATH
    ln -s $BASE_PATH/ShellSpace/tools/shell-command/vim.sh vim.sh 
    ln -s $BASE_PATH/ShellSpace/tools/shell-command/vimdiff.sh vimdiff.sh 
    ln -s $BASE_PATH/ShellSpace/tools/shell-command/du.sh du.sh 
    ln -s $BASE_PATH/ShellSpace/tools/shell-command/sed.sh sed.sh
fi 
